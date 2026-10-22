module RedmineProgressBars
  # Хук страницы проекта: блок с прогресс-баром в левой колонке
  # страницы обзора проекта (view_projects_show_left).
  class Hooks < Redmine::Hook::ViewListener
    render_on :view_projects_show_left, partial: 'hooks/redmine_progress_bars/project'
  end
end
