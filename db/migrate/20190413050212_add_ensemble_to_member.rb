class AddEnsembleToMember < ActiveRecord::Migration[5.2]
  def change
    add_reference :members, :ensemble, foreign_key: true, index: true, optional: true
  end
end
