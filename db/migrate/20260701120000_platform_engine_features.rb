# frozen_string_literal: true

class PlatformEngineFeatures < ActiveRecord::Migration[8.0]
  def change
    add_column :payments, :status, :string, default: 'pending', null: false
    add_column :payments, :provider, :string
    add_column :payments, :failure_reason, :string
    add_column :payments, :sc_payment_intent_id, :string
    add_column :payments, :sc_payment_secret, :string
    add_index :payments, :status

    add_column :order_items, :snapshot, :jsonb, default: {}, null: false

    add_column :users, :stripe_customer_id, :string
    add_index :users, :stripe_customer_id

    add_column :franchises, :service_charge_percent, :decimal, precision: 5, scale: 2, default: 20.0

    create_table :wallets do |t|
      t.references :franchise, null: false, foreign_key: true, index: { unique: true }
      t.bigint :available_balance_cents, default: 0, null: false
      t.bigint :pending_balance_cents, default: 0, null: false
      t.timestamps
    end

    create_table :wallet_transactions do |t|
      t.references :wallet, null: false, foreign_key: true
      t.bigint :amount_cents, null: false
      t.string :kind, null: false
      t.string :reference, null: false
      t.references :source, polymorphic: true
      t.jsonb :metadata, default: {}, null: false
      t.datetime :released_at
      t.timestamps
      t.index :reference, unique: true
      t.index :kind
    end

    create_table :notification_deliveries do |t|
      t.references :notification, null: false, foreign_key: true
      t.string :channel, null: false
      t.string :status, default: 'pending', null: false
      t.text :error_message
      t.datetime :delivered_at
      t.timestamps
      t.index %i[notification_id channel], unique: true
    end

    add_column :notifications, :kind, :string
    add_column :notifications, :category, :string
    add_column :notifications, :channels, :string, array: true, default: []
    add_column :notifications, :channel_payloads, :jsonb, default: {}, null: false
    add_column :notifications, :notifiable_type, :string
    add_column :notifications, :notifiable_id, :bigint
    add_column :notifications, :franchise_id, :bigint
    add_column :notifications, :bypass_preferences, :boolean, default: false, null: false
    add_index :notifications, %i[notifiable_type notifiable_id]
    add_index :notifications, :kind

    create_table :auth_identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :provider, null: false
      t.string :uid, null: false
      t.jsonb :info, default: {}, null: false
      t.jsonb :credentials, default: {}, null: false
      t.timestamps
      t.index %i[provider uid], unique: true
    end

    create_table :franchise_page_visits do |t|
      t.references :franchise, null: false, foreign_key: true
      t.string :visitor_uuid, null: false
      t.bigint :user_id
      t.string :path
      t.timestamps
      t.index %i[franchise_id created_at]
      t.index %i[franchise_id visitor_uuid]
    end

    reversible do |dir|
      dir.up do
        execute <<~SQL.squish
          UPDATE payments SET status = 'completed' WHERE paid = true;
          UPDATE payments SET status = 'pending' WHERE paid IS NOT TRUE OR paid = false;
        SQL
      end
    end
  end
end
