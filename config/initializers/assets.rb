# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')
# Rails.application.config.assets.paths << Rails.root.join('internal/pdf')

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )

Rails.application.config.assets.precompile += ['internal/pdf/medical-form-v4.scss', 'internal/pdf/registration_invoice.scss','inspectorate/visit_plan_listing.scss','pdf/fontawesome/fontawesome.min.css','pdf/fontawesome/webfonts/*','pdf/doctor_result_report.scss','pdf/xray_result_report.scss','pdf/doctor_wall_list.scss', 'internal/pdf/pdf.scss','pdf/visit_report_explanation_letter.scss','inspectorate/inspectorate.scss','inspectorate/lqcc.scss','pdf/lqcc_visit_summary.scss','dashboards/stylenew.css','dashboards/daterangepicker.css','dashboards/jquery.slim.min.js','dashboards/bootstrap.js','dashboards/daterangepicker.min.js','dashboards/common.js']
