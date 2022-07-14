require_relative "errors/branch_invalid_error"
require "pry"

class Teletime
  def initialize(storage)
    @storage = storage
  end

  def overview
    storage.get
  end

  def reset
    empty_telephone = {
      a: {names: [], deadline: 0, status: "free"},
      b: {names: [], deadline: 0, status: "free"},
      c: {names: [], deadline: 0, status: "free"},
      d: {names: [], deadline: 0, status: "free"},
      e: {names: [], deadline: 0, status: "free"}
    }

    storage.store(empty_telephone)
  end

  def add(branch, username)
    branch = format_branch(branch)
    validate_branch(branch)

    telephone = storage.get
    telephone[branch.to_sym][:names].append(username)
    telephone[branch.to_sym][:deadline] = (Time.now + (60 * 60 * 72)).to_i
    telephone[branch.to_sym][:status] = "in progress"
    storage.store(telephone)
  end

  def set_status(branch, status)
    branch = format_branch(branch)
    validate_branch(branch)

    telephone = storage.get
    telephone[branch.to_sym][:deadline] = 0
    telephone[branch.to_sym][:status] = status
    storage.store(telephone)
  end

  def clear_list(branch)
    branch = format_branch(branch)
    validate_branch(branch)

    telephone = storage.get
    telephone[branch.to_sym][:names] = []
    telephone[branch.to_sym][:deadline] = 0
    telephone[branch.to_sym][:status] = "free"
    storage.store(telephone)
  end

  def manual_list(branch, names)
    branch = format_branch(branch)
    validate_branch(branch)

    telephone = storage.get
    telephone[branch.to_sym][:names] = names.split(",").map(&:strip)
    storage.store(telephone)
  end

  def set_hours(branch, hours)
    branch = format_branch(branch)
    validate_branch(branch)

    telephone = storage.get
    telephone[branch.to_sym][:deadline] = (Time.now + (60 * 60 * hours)).to_i
    storage.store(telephone)
  end

  def amend(branch, new_name)
  branch = format_branch(branch)
  validate_branch(branch)
  
  telephone = storage.get
  telephone[branch.to_sym][:names].pop
  telephone[branch.to_sym][:names] << new_name
  storage.store(telephone)
  end

private
  attr_reader :storage

  def format_branch(branch)
    branch.downcase.strip.to_sym
  end

  def validate_branch(branch)
    branches = storage.get.keys
    return if branches.include?(branch)
    raise BranchInvalidError
  end
end
