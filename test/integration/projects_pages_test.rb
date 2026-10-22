require File.expand_path('../../test_helper', __FILE__)

class RedmineProgressBarsPagesTest < Redmine::IntegrationTest
  fixtures :all

  test 'projects list shows progress column and per-project bars' do
    log_user 'admin', 'admin'
    get '/projects'
    assert_response :success
    assert_select 'table.list.projects th.rpbb-cell'
    assert_select 'table.list.projects td.rpbb-cell .rpbb-track', :minimum => 1
  end

  test 'project overview page shows progress bar block' do
    log_user 'admin', 'admin'
    get '/projects/ecookbook'
    assert_response :success
    assert_select '#rpbb-project-overview .rpbb-track'
    assert_select '#rpbb-project-overview .rpbb-fill[style*="width"]'
  end
end
