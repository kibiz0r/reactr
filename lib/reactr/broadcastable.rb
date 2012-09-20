module Reactr
  module Broadcastable
    include Streamable
# 
#     def select(&block)
#       Streamer.new.tap do |broadcaster|
#         broadcaster.select(&block).subscribe self
#       end
#     end
# 
#     def reject(&block)
#       Streamer.new.tap do |broadcaster|
#         broadcaster.reject(&block).subscribe self
#       end
#     end
# 
#     def map(&block)
#       Streamer.new.tap do |broadcaster|
#         broadcaster.map(&block).subscribe self
#       end
#     end
  end
end
