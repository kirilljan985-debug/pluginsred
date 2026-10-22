module RedmineProgressBars
  # Расчёт прогресса проекта. Чистая логика без Rails/Redmine-зависимостей —
  # покрывается обычным minitest. Единственный метод, касающийся AR-моделей,
  # это for_project.
  module Progress
    module_function

    # issues: перечислимый набор объектов, отвечающих на #closed? и #done_ratio.
    # Возвращает {percent:, total:, closed:, open:} или nil, если задач нет.
    # Закрытые задачи считаются выполненными на 100%, открытые добавляют свой
    # done_ratio (0..100).
    def compute(issues)
      total = 0
      closed = 0
      open_done_sum = 0

      issues.each do |issue|
        total += 1
        if issue.closed?
          closed += 1
        else
          open_done_sum += issue.done_ratio.to_i
        end
      end

      return nil if total.zero?

      {
        percent: (((closed * 100.0) + open_done_sum) / total).round,
        total: total,
        closed: closed,
        open: total - closed
      }
    end

    # Прогресс конкретного проекта по видимым текущему пользователю задачам.
    def for_project(project)
      return nil unless project
      compute(project.issues.visible)
    end
  end
end
