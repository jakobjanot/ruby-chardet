# frozen_string_literal: true

######################## BEGIN LICENSE BLOCK ########################
# The Original Code is mozilla.org code.
#
# The Initial Developer of the Original Code is
# Netscape Communications Corporation.
# Portions created by the Initial Developer are Copyright (C) 1998
# the Initial Developer. All Rights Reserved.
#
# Contributor(s):
#   Jeff Hodges - port to Ruby
#   Mark Pilgrim - port to Python
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
  class EscCharSetProber < CharSetProber
    def initialize
      super()
      @codingSM = [
        CodingStateMachine.new(HZSMModel),
        # CodingStateMachine.new(ISO2022CNSMModel), # Not supported in Ruby
        CodingStateMachine.new(ISO2022JPSMModel),
        # CodingStateMachine.new(ISO2022KRSMModel)  # Not supported in Ruby
      ]
      reset
    end

    def reset
      super()
      for codingSM in @codingSM
        next unless codingSM
        codingSM.active = true
        codingSM.reset
      end
      @activeSM = @codingSM.length
      @detectedCharset = nil
    end

    def charset_name
      @detectedCharset
    end

    def confidence
      @detectedCharset ? 0.99 : 0.00
    end

    def feed(aBuf)
      aBuf.each_byte do |b|
        c = b.chr
        for codingSM in @codingSM
          next unless codingSM
          next unless codingSM.active
          codingState = codingSM.next_state(c)
          if codingState == EError
            codingSM.active = false
            @activeSM -= 1
            if @activeSM <= 0
              @state = ENotMe
              return state
            end
          elsif codingState == EItsMe
            @state = EFoundIt
            @detectedCharset = codingSM.coding_state_machine
            return state
          end
        end
      end

      state
    end
  end
end
