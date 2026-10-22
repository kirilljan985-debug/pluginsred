require File.expand_path('../../test_helper', __FILE__)

class RedmineProgressBarsProgressTest < ActiveSupport::TestCase
  # Заглушка для чистой логики compute (без AR)
  class FakeIssue
    attr_reader :done_ratio

    def initialize(closed, done_ratio)
      @closed = closed
      @done_ratio = done_ratio
    end

    def closed?
      @closed
    end
  end

  test 'compute returns nil for empty set' do
    assert_nil RedmineProgressBars::Progress.compute([])
  end

  test 'compute mixes closed issues (100%) and open done_ratio' do
    issues = [
      FakeIssue.new(true, 0),
      FakeIssue.new(false, 50),
      FakeIssue.new(false, 80)
    ]
    result = RedmineProgressBars::Progress.compute(issues)
    assert_equal 77, result[:percent] # (100 + 50 + 80) / 3 = 76.67 -> 77
    assert_equal 3, result[:total]
    assert_equal 1, result[:closed]
    assert_equal 2, result[:open]
  end

  test 'compute gives 100 percent when all issues closed' do
    result = RedmineProgressBars::Progress.compute([FakeIssue.new(true, 0), FakeIssue.new(true, 70)])
    assert_equal 100, result[:percent]
    assert_equal 2, result[:total]
    assert_equal 0, result[:open]
  end

  test 'compute gives 0 percent for all-new open issues' do
    result = RedmineProgressBars::Progress.compute([FakeIssue.new(false, 0), FakeIssue.new(false, 0)])
    assert_equal 0, result[:percent]
  end

  # Проверка на реальных моделях Redmine
  fixtures :projects, :users, :trackers, :issue_statuses, :enumerations

  test 'for_project computes over project issues' do
    project = Project.create!(:name => 'rpbb-test', :identifier => 'rpbb-test')
    common = {
      :project => project,
      :tracker => Tracker.first,
      :priority => IssuePriority.first,
      :author => User.find(2)
    }
    Issue.create!(common.merge(:subject => 'open 50', :done_ratio => 50))
    Issue.create!(common.merge(:subject => 'closed', :status => IssueStatus.where(:is_closed => true).first))

    result = RedmineProgressBars::Progress.for_project(project)
    assert_equal 75, result[:percent] # (100 + 50) / 2
    assert_equal 2, result[:total]
    assert_equal 1, result[:closed]
  end

  test 'for_project returns nil for project without issues' do
    project = Project.create!(:name => 'rpbb-empty', :identifier => 'rpbb-empty')
    assert_nil RedmineProgressBars::Progress.for_project(project)
  end
end
