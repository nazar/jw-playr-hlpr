# Copyright (c) 2009 Nazar Aziz - Panther Software Publishing Limited - nazar@panthersoftware.com
#
# Based on Farooq Ali's Flash Playr Hlpr - http://www.jroller.com/abstractScope/entry/flash_mp3_imageslideshow_media_player
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module PSP
  module JwPlayerHelper
    
    DEFAULT_FLASH_OPTIONS = {
                                :player_id         => 'jw_player',
                                :id                => 'flash_player',
                                :allowfullscreen   => 'true',
                                :allowscriptaccess => 'true',
                                :play              => 'true',
                                :menu              => 'false',
                                :quality           => 'autohigh',
                                :scale             => 'default',
                                :width             => 400,
                                :height            => 300,
                            } unless const_defined?('DEFAULT_FLASH_OPTIONS')

    FLASH_REQUIRED_MESSAGE = "You must enable JavaScript and install the <a href='http://www.flash.com'>Flash</a> plugin to view this player" unless const_defined?('FLASH_REQUIRED_MESSAGE')

    # JW player helper
    def player(player_options = {}, flash_options = {})
      flash_options   = DEFAULT_FLASH_OPTIONS.dup.update(flash_options)
      container       = "#{flash_options[:id]}_container"
      msg             = flash_options[:flash_required_message].nil? ? FLASH_REQUIRED_MESSAGE : flash_options[:flash_required_message]
      #if DEFAULT_SKIN defined then use that, otherwise look in player_options[:skin]. Don't specify if neither are set
      skin = player_options[:skin].blank? ? (PSP::JwPlayerHelper.const_defined?('DEFAULT_SKIN') ? DEFAULT_SKIN : '') : player_options[:skin]
      player_options[:skin] = "/swf/skins/#{skin}.swf" unless skin.blank?
      
      js = "var swf_obj = new SWFObject('/swf/player.swf','#{flash_options[:player_id]}','#{flash_options[:width]}','#{flash_options[:height]}','9');" <<
           options_for_swfobject(container, flash_options, player_options)

      content_tag('div', msg , :id => container) << javascript_tag(js)
    end

    protected

    def swfobject_params(options)
      options.collect { |k,v| "swf_obj.addParam('#{k.to_s}','#{v.to_s}')" }.join('; ')
    end

    def flashvars_params(options)
      options.collect {|k,v| "#{k.to_s}=#{CGI::escape(v.to_s)}"}.join('&')
    end

    def options_for_swfobject(dom_id, flash_options, player_options)
      options = flash_options.dup
      [:id, :player_id].each{|key| options.delete(key)}
      #flashvars first
      flashvars    = flashvars_params(player_options)
      #finally swf params, including the constructed flashvars
      flash_script = swfobject_params(options.merge({:flashvars => flashvars}))
      flash_script << ";swf_obj.write('#{dom_id}');"
    end


  end
end
