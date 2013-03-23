class GitHubBlock < Liquid::Block

  require 'github_api'

  # Cache these values for the lifetime of Jekyll
  @@github = Github.new
  @@repos = {}

  def initialize(tag_name, text, tokens)
    super

    @attributes = {}

    text.scan(Liquid::TagAttributes) do |key, value|
      @attributes[key] = value
    end

    @user = @attributes['user']

    # Grab Github feed here
    if !@@repos[@user]
      @@repos[@user] = @@github.repos.all({:user => @user})

      # We also grab the user's gists, modifying them to roughly fit the definitions
      # that is being used by the repo's, and then appending them to the list.
      gists = []

      @@github.gists.all({:user => @user}) do |gist|
        gist['pushed_at'] = gist['created_at']
        gist['name'] = 'Gist'
        gist['language'] = gist['files'].map { |f| f[1]['language'] || 'Text' }.join ', '

        gists << gist
      end

      @@repos[@user] = @@repos[@user].to_a.concat(gists)
    end
  end

  def render(context)
    context.stack do
      context['repos'] = @@repos[@user]
      render_all(@nodelist, context)
    end
  end

end

Liquid::Template.register_tag('github', GitHubBlock)
