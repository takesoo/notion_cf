# NotionCf

This is a CLI that allows you to manage Notion blocks, databases, and pages like AWS Cloud Formation using YAML files.

## Installation

Add to Gemfile

```
gem 'notion_cf'
```

Run `bundle install`.

## Usage
### 1. Create a New Integration

To create a new integration, follow the steps 1 & 2 outlined in the [Notion documentation](https://developers.notion.com/docs/getting-started#getting-started). The “Internal Integration Token” is what is going to be used to authenticate API calls (referred to here as the “API token”).

### 2. Set .env
```
cp .env.sample .env
```
And then, set your secret_key.

### 3. Type Command

```
# deploy from template file

notion_cf deploy {page_id} template/sample.yaml

# generate template file from exist page
notion_cf generate {page_id}
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/takesoo/notion_cf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/takesoo/notion_cf/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NotionCf project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/takesoo/notion_cf/blob/master/CODE_OF_CONDUCT.md).
