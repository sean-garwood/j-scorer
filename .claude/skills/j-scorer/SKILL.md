---
name: j-scorer
description: >
  Version facts and gotchas specific to this app's Ruby, Rails, and gem stack.
  Complements the general ruby and rails skills.
when_to_use: >
  Running, testing, or changing j-scorer's config, dependencies, or
  autoloaded code; checking whether a general Ruby/Rails claim applies here.
---

Re-check these against `Gemfile.lock` and `config/` before relying on them; they go stale on every bump.
They should be updated alongside what they name--you should just do so when the
bump happens.

## Stack
- Ruby 3.1.2 (`.ruby-version`, rbenv).
- Rails 6.1.6.1, Postgres (`pg` 1.4.3), Puma 5.6.4, Minitest.
- Assets: sprockets 3.7.2, sass-rails 5.1.0, uglifier, jquery-rails. No webpacker.
- Psych isn't in the lockfile, so the bundle uses Ruby 3.1.2's built-in Psych 4.
  - `ruby` outside the bundle loads a newer installed Psych; check versions with `bundle exec`.

## Gotchas
- `config.load_defaults 5.2` on Rails 6.1, and no `config.autoloader` set, so the app uses the classic autoloader, not Zeitwerk.
  - Run `bin/rails zeitwerk:check` before switching autoloaders; classic is removed in Rails 7.
  - Non-standard autoload dirs: `app/stats`, `app/serializers`, `app/validators`.
- `config/database.yml` uses YAML aliases (`<<: *default`), which Psych 4 rejects unless Rails loads it with `aliases: true`.
- Reloading uses `config.cache_classes`, not `enable_reloading`.
- No `test/system`; `bin/rails test` covers every test dir.
- `RAILS_MAX_THREADS` sets the DB pool (`database.yml`) and Puma threads; production pool also reads `DB_POOL`.
- `config/database.yml.travis` is stale Travis CI config.
- A fresh checkout needs `bundle install`: without it, `bin/rails` fails with `Bundler::GemNotFound`.
