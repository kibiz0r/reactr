require 'bubble-wrap/loader'
require 'bubble-wrap/coalesce'
require 'konjure'

BubbleWrap.require 'lib/reactr/**/*.rb' do
  file('lib/reactr/stream.rb').depends_on ['lib/reactr/subscription.rb', 'lib/reactr/streamable.rb', 'lib/reactr/stream_ended_error.rb']
  file('lib/reactr/streamer.rb').depends_on 'lib/reactr/stream.rb'
  file('lib/reactr/attr_stream.rb').depends_on 'lib/reactr/streamer.rb'
  file('lib/reactr/attr_streamer.rb').depends_on 'lib/reactr/streamer.rb'
  file('lib/reactr/module_ext.rb').depends_on ['lib/reactr/attr_stream.rb', 'lib/reactr/attr_streamer.rb']
end
