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
      @@repos[@user] = @@github.repos.all :user => @user
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
