class CreateInquiries < ActiveRecord::Migration
  def up
    unless ::Refinery::Inquiries::Inquiry.table_exists?
      create_table :refinery_inquiries_inquiries, force: true do |t|
        t.string   :name,     null: false
        t.string   :email,    null: false
        t.string   :phone
        t.text     :message,  null: false
        t.boolean  :spam,     null: false, default: false
        t.boolean  :archived, null: false, default: false
        t.timestamps null: false
      end
    end
  end

  def down
     drop_table ::Refinery::Inquiries::Inquiry.table_name

     ::Refinery::Page.delete_all({
       plugin_page_id: ('refinery_inquiries' || 'refinery_inquiries_thank_you')
     }) if defined?(::Refinery::Page)
  end
end
