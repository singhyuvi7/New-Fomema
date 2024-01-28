Raven.configure do |config|
    config.dsn = 'https://5f106115969e460dbaa5786c7afd8038:938ba5ecee80457a82f6425829f45dc9@sentry.io/2842849'
    config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
    config.environments = %w(production production1 production2 production3 staging stagingali stagingali2)
    # Please note, every environment manually included except development & test.
end