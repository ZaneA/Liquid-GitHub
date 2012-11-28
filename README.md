Liquid-GitHub
===

A custom block for the Liquid templating engine (and therefore Jekyll) that allows you to iterate over a user's GitHub repositories.

Usage
---

First of all, install the `github_api` gem which is used to actually interact with the GitHub v3 API.

```bash
gem install github_api
```
The actual usage is very simple. The block simply takes a GitHub user and provides a `repos` variable containing the API results.

```html+jinja
{% github user: ZaneA %}
  {% for repo in repos %}
    <h3>{{ repo.name }}</h3>
    {{ repo.description | markdownify }}
  {% endfor %}
{% endgithub %}
```

You might like to check out my [Liquid-Sort](/ZaneA/Liquid-Sort) repository in order to easily sort these results by a key.