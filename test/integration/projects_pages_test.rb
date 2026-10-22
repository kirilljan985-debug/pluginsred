require File.expand_path('../../test_helper', __FILE__)

class RedmineProgressBarsPagesTest < Redmine::IntegrationTest
  fixtures :all

  test 'projects page in default board view shows progress bars' do
    log_user 'admin', 'admin'
    get '/projects'
    assert_response :success
    assert_select '#projects-index .rpbb-track', :minimum => 1
  end

  test 'projects page in list view shows progress column and per-project bars' do
    log_user 'admin', 'admin'
    Setting.project_list_display_type = 'list'
    get '/projects', :params => { :display_type => 'list' }
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
