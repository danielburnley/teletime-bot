class TeletimeDisplay
  def format_teletime(teletime)
    res = []
    res << "**__Current Slots__**"

    teletime.each do |k, v|
      res << format_branch_current_slot(k, v)
    end

    res << ""
    res << "**__Branch Status__**"

    teletime.each do |k, v|
      res << format_branch_current_status(k, v)
    end

    res.join("\n")
  end

  def format_teletime_reset(teletime)
    update = "Telephone reset!"

    "#{update}\n\n#{format_teletime(teletime)}"
  end

  def format_branch_updated(branch, username, teletime)
    update = "#{username} added to branch #{branch.upcase}."

    "#{update}\n\n#{format_teletime(teletime)}"
  end

  def format_branch_hours_updated(branch, teletime)
    update = "Branch #{branch.upcase} now due #{timestamp_to_discord(teletime[branch.downcase.to_sym][:deadline])}."

    "#{update}\n\n#{format_teletime(teletime)}"
  end

  def format_branch_cleared(branch, teletime)
    update = "Branch #{branch.upcase} cleared."

    "#{update}\n\n#{format_teletime(teletime)}"
  end

  def format_branch_manually_set(branch, teletime)
    update = "Branch #{branch.upcase} manually set."

    "#{update}\n\n#{format_teletime(teletime)}"
  end

  def format_branch_status_update(branch, status, teletime)
    update = "Branch #{branch.upcase} is now **#{status}**"

    "#{update}\n\n#{format_teletime(teletime)}"
  end

private

  def format_branch_current_slot(branch, status)
    if(status[:status] == "in progress")
      names = status[:names]
      return "**#{branch.to_s.upcase}(#{names.last}):** #{timestamp_to_discord(status[:deadline])}"
    else
      return "**#{branch.to_s.upcase}(#{status[:status]}):** n/a"
    end
  end

  def format_branch_current_status(branch, status)
    "#{branch.to_s.upcase}: #{status[:names].join(", ")} (#{status[:names].count})"
  end

  def timestamp_to_discord(timestamp)
    "<t:#{timestamp}:R>"
  end
end
