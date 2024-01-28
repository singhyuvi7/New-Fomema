class UpdateCustomQueryOptions
    include Sidekiq::Worker

    def perform(*args)
        organization_ids    = ActiveRecord::Base.connection.execute("select distinct(users.userable_id)
            from foreign_workers fw join users on users.id = fw.created_by
            where users.userable_type = 'Organization'").to_a.map(&:values).flatten

        options = Organization.where(id: organization_ids).pluck(:name, :id).sort
        cqo     = CustomQueryOption.find_or_initialize_by(name: "HCM Report Branch List")
        cqo.update(query_options: options)
    end
end