# frozen_string_literal: true

######################## BEGIN LICENSE BLOCK ########################
# The Original Code is Mozilla Universal charset detector code.
#
# The Initial Developer of the Original Code is
# Netscape Communications Corporation.
# Portions created by the Initial Developer are Copyright (C) 2001
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Jeff Hodges - port to Ruby
#   Mark Pilgrim - port to Python
#   Shy Shalom - original C code
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301  USA
######################### END LICENSE BLOCK #########################

module CharDet
  class CharSetProber
    attr_accessor :active
    def initialize; end

    def reset
      @state = EDetecting
    end

    def charset_name
      nil
    end

    def feed(aBuf); end

    attr_reader :state

    def confidence
      0.0
    end

    def filter_high_bit_only(aBuf)
      aBuf.gsub(/([\x00-\x7F])+/, " ")
    end

    def filter_without_english_letters(aBuf)
      aBuf.gsub(/([A-Za-z])+/, " ")
    end

    def filter_with_english_letters(aBuf)
      # TODO
      aBuf
    end
  end
end
