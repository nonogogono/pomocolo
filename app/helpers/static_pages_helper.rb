module StaticPagesHelper
  def task_time_value
    if current_user.task_time
      current_user.task_time
    else
      Constants::DEFAULT_TASK_TIME
    end
  end

  def break_time_value
    if current_user.break_time
      current_user.break_time
    else
      Constants::DEFAULT_BREAK_TIME
    end
  end
end
