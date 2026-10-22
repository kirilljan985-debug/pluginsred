# Redmine Progress Bars

Плагин Redmine: **прогресс-бар для каждого проекта**.

- На странице **«Проекты»** (`/projects`) — прогресс-бар, процент и счётчик
  задач у каждого проекта в списке (и в карточном виде `board`, и в таблице
  `list` с колонкой «Прогресс»).
- На **странице обзора** каждого проекта — блок «Прогресс» в левой колонке
  (рядом с таблицей задач).

## Как считается прогресс

Закрытые задачи считаются выполненными на 100%, открытые добавляют своё поле
«% готовности» (done_ratio). Итог — среднее по всем видимым текущему
пользователю задачам проекта (задачи подпроектов не учитываются).

Прогресс виден только тем, у кого есть право `view_issues` в проекте;
приватные задачи учитываются с учётом своей видимости.

## Совместимость

- Redmine **6.0+** (CI гоняет тесты против `7.0-stable` и `master`, Ruby 3.2+)
- Работает в **обоих представлениях** списка проектов: карточное `board`
  (по умолчанию в Redmine 7) и табличное `list` (колонка «Прогресс»).
- Оба шаблона основаны на Redmine 7.0 (`projects/_board`, `projects/_list`) —
  при крупном обновлении Redmine сверьте их с ядром.

## Установка

1. Склонировать репозиторий в папку плагинов Redmine под именем плагина:

   ```
   cd /path/to/redmine/plugins
   git clone https://github.com/kirilljan985-debug/pluginsred.git redmine_progress_bars
   ```

2. Перезапустить Redmine. Миграций БД у плагина нет — больше шагов не нужно.

3. В production при необходимости выполните `bundle exec rake assets:precompile`
   (в Redmine 6+ ассеты плагинов подключаются через Propshaft).

## Тесты

Внутри установленного Redmine:

```
bundle exec rake redmine:plugins:test NAME=redmine_progress_bars RAILS_ENV=test
```

CI: GitHub Actions прогоняет юнит- и интеграционные тесты на Redmine
`7.0-stable` и `master` при каждом push (`.github/workflows/test.yml`).

## Структура

```
init.rb                                    регистрация плагина
lib/redmine_progress_bars.rb               корень модуля
lib/redmine_progress_bars/progress.rb      расчёт прогресса (чистая логика)
lib/redmine_progress_bars/hooks.rb         хук страницы проекта (view_projects_show_left)
app/views/hooks/redmine_progress_bars/     партиал блока прогресса на странице проекта
app/views/projects/_list.html.erb          переопределение списка-таблицы (+колонка «Прогресс»)
app/views/projects/_board.html.erb         переопределение карточного списка (+бар на карточке)
assets/stylesheets/redmine_progress_bars.css
config/locales/en.yml, ru.yml              локализация
test/unit, test/integration                тесты (minitest, запускаются в окружении Redmine)
```

## Лицензия

GPL-2.0-or-later (см. `LICENSE`). Файл `app/views/projects/_list.html.erb`
основан на шаблоне ядра Redmine 7.0.

---

### English

Redmine plugin that adds a progress bar for every project: a "Progress"
column on the projects list page (`/projects`) and a "Progress" box on each
project's overview page. Closed issues count as 100%, open issues contribute
their done_ratio; the result is averaged over the project's issues visible to
the current user. Requires Redmine 6.0+ (tested against 7.0), Ruby 3.2+.
Install: clone this repository into `plugins/redmine_progress_bars` and
restart Redmine. License: GPL-2.0-or-later.
