class ChecklistQuestion < ActiveRecord::Base
  attr_accessible :question, :varname, :ordering, :update_callback, :init_callback
  has_many :answers, class_name: 'ChecklistAnswer', dependent: :destroy, autosave: true
  belongs_to :scoretype
  belongs_to :checklist
end
