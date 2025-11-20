# frozen_string_literal: true

module Stripe
  module Resource
    def self.included(base)
      base.extend(ClassMethods)
      base.class_variable_set(:@@api_version, 'v1')
    end

    module ClassMethods
      def api_version(version = nil)
        if version
          class_variable_set(:@@api_version, version.to_s)
        else
          class_variable_get(:@@api_version)
        end
      end

      def connection
        case api_version
        when 'v2'
          Stripe.connection_v2
        else
          Stripe.connection
        end
      end

      def create(**params)
        payload = make_payload(**params)
        response = connection.request(
          method: :post,
          path: path,
          data: payload
        )
        new(Stripe.deep_transform(response))
      end

      def update(resource_id:, **params)
        raise Stripe::Error::MissingArguments, "#{resource_name}_id is required" unless resource_id

        payload = make_payload(**params)
        response = connection.request(
          method: :post,
          path: "#{path}/#{resource_id}",
          data: payload
        )
        new(Stripe.deep_transform(response))
      end

      def retrieve(resource_id)
        raise Stripe::Error::MissingArguments, "#{resource_name}_id is required" unless resource_id

        response = connection.request(method: :get, path: "#{path}/#{resource_id}")
        new(Stripe.deep_transform(response))
      rescue Stripe::Error::RequestFailed => e
        error_message = connection.parse_error(e)
        Rails.logger.debug error_message['error']['message'] if error_message

        nil
      end

      def delete(resource_id)
        raise Stripe::Error::MissingArguments, "#{resource_name}_id is required" unless resource_id

        response = connection.request(method: :delete, path: "#{path}/#{resource_id}")
        new(Stripe.deep_transform(response))
      rescue Stripe::Error::RequestFailed => e
        error_message = connection.parse_error(e)
        Rails.logger.debug error_message['error']['message'] if error_message

        nil
      end

      def path
        const_get(:PATH)
      end

      private

      def resource_name
        name.demodulize.underscore
      end
    end
  end
end
