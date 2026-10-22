# Redmine Progress Bars
# Прогресс-бары для проектов: на странице списка проектов и на странице проекта.
# Лицензия: GPL-2.0-or-later (совместимо с лицензией Redmine).
require 'redmine'
require_relative 'lib/redmine_progress_bars/progress'
require_relative 'lib/redmine_progress_bars/hooks'

Redmine::Plugin.register :redmine_progress_bars do
  name 'Redmine Progress Bars'
  author 'kirilljan985-debug'
  description 'Shows a progress bar for each project: on the projects list page and on the project overview page.'
  version '1.0.0'
  url 'https://github.com/kirilljan985-debug/pluginsred'
  author_url 'https://github.com/kirilljan985-debug'
  requires_redmine version_or_higher: '6.0.0'
end
