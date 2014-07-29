module PseudoCMS
  module API
    module Pagination

      # has_first_page?, has_prev_page?, has_next_page?, has_last_page?
      # first_page, prev_page, next_page, last_page
      [:first, :prev, :next, :last].each do |rel|
        send(:define_method, "#{rel.to_s}_page") do
          last_response.rels[rel] if last_response
        end

        send(:define_method, "has_#{rel.to_s}_page?") do
          !!(last_response && last_response.rels[rel])
        end
      end
    end
  end
end
