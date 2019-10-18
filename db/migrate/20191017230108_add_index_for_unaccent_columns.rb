class AddIndexForUnaccentColumns < ActiveRecord::Migration[5.2]
  def change
    execute <<-SQL
      CREATE EXTENSION IF NOT EXISTS pg_trgm;
      CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;
      
      CREATE OR REPLACE FUNCTION immutable_unaccent(varchar)
        RETURNS text AS $$
          SELECT unaccent($1)
        $$ LANGUAGE sql IMMUTABLE;
      
      CREATE INDEX index_memberships_on_unaccent_name ON memberships USING gist (immutable_unaccent(name) gist_trgm_ops);
      CREATE INDEX index_members_on_unaccent_name ON members USING gist (immutable_unaccent(name) gist_trgm_ops);
    SQL
  end
end
