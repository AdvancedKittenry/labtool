class ChecklistTopic < ActiveRecord::Base
  attr_accessible :title, :varname, :ordering, :update_callback, :init_callback
  has_many :topics_checks, class_name: 'ChecklistTopicsCheck', dependent: :destroy, autosave: true
  has_many :checks, class_name: 'ChecklistCheck', through: :topics_checks, autosave: true

  belongs_to :scoretype
  belongs_to :checklist
end
