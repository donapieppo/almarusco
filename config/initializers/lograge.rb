Rails.application.configure do
  if config.unibo_common.lograge
    config.lograge.enabled = true
    config.lograge.formatter = Lograge::Formatters::Json.new
    config.lograge.custom_payload do |controller|
      if !controller.is_a?(Rails::HealthController)
        res = {
          host: controller.request.host,
          current_user: controller.current_user&.upn,
          current_organization: controller.current_organization&.code
        }
        if controller.current_user != controller.true_user
          res[:true_user] = controller.true_user&.upn
        end
        res
      end
    end
  end
end
