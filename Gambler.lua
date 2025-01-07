----------------------------------------------
------------MOD CODE -------------------------
SMODS.Atlas{
    key = 'GamblersJokes', --atlas key
    path = 'GamblersJokes.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

--[[SMODS.Joker{
    key = 'Ludens', --joker key
    loc_txt = { -- local text
        name = "Luden's Companion",
        text = {
          'When Triggered',
          'Gain {X:mult,C:white}X#1#{} Mult',
          'And Gain {C:chips}+#2# Chips',
        },
        --[[unlock = {
            '',
        }]]
--    },
--[[    config = { extra = { chips = 15, Xmult = 4}},
    atlas = 'GamblersJokes', --atlas' key
    rarity = 2, --rarity: 1 = Common, 2 = Uncommon, 3 = Rare, 4 = Legendary
    --soul_pos = { x = 0, y = 0 },
    cost = 12, --cost
    unlocked = true, --where it is unlocked or not: if true, 
    discovered = true, --whether or not it starts discovered
    blueprint_compat = true, --can it be blueprinted/brainstormed/other
    eternal_compat = false, --can it be eternal
    perishable_compat = false, --can it be perishable
    pos = {x = 0, y = 0}, --position in atlas, starts at 0, scales by the atlas' card size (px and py): {x = 1, y = 0} would mean the sprite is 71 pixels to the right
   
    loc_vars = function(self,info_queue,center)
        info_queue[#info_queue+1] = G.P_CENTERS.j_joker --adds "Joker"'s description next to this card's description
        return {vars = {center.ability.extra.Xmult, card.ability.extra.chips}} --#1# is replaced with card.ability.extra.Xmult
    end,
    check_for_unlock = function(self, args)
        if args.type == 'shotgun' then --not a real type, just a joke
            unlock_card(self)
        end
        unlock_card(self) --unlocks the card if it isnt unlocked
    end,
    calculate = function(self,card,context)
        if context.joker_main then
            return {
                card = card,
                chip_mod = card.ability.extra.chips,
                Xmult_mod = card.ability.extra.Xmult,
                message = 'X' .. card.ability.extra.Xmult,
                colour = G.C.MULT
            }
        end
    end,
    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return true
    end,
}
]]
SMODS.Joker {
    key = 'Ludens',
    loc_txt = {
      name = "Luden's Companion",
      text = {
        "Gains {C:chips}+#2#{} Chips",
        "if played hand",
        "contains a {C:attention}Straight{}",
        "{C:inactive}(Currently {C:chips}+#1#{C:inactive} Chips)"
      }
    },
    config = { extra = { chips = 0, chip_gain = 15 } },
    rarity = 2,
    atlas = 'GamblersJokes',
    pos = { x = 0, y = 0 },
    cost = 5,
    loc_vars = function(self, info_queue, card)
      return { vars = { card.ability.extra.chips, card.ability.extra.chip_gain } }
    end,
    calculate = function(self, card, context)
      if context.joker_main then
        return {
          chip_mod = card.ability.extra.chips,
          message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips } }
        }
      end
  
      -- context.before checks if context.before == true, and context.before is true when it's before the current hand is scored.
      -- (context.poker_hands['Straight']) checks if the current hand is a 'Straight'.
      -- The 'next()' part makes sure it goes over every option in the table, which the table is context.poker_hands.
      -- context.poker_hands contains every valid hand type in a played hand.
      -- not context.blueprint ensures that Blueprint or Brainstorm don't copy this upgrading part of the joker, but that it'll still copy the added chips.
      if context.before and next(context.poker_hands['Straight']) and not context.blueprint then
        -- Updated variable is equal to current variable, plus the amount of chips in chip gain.
        -- 15 = 0+15, 30 = 15+15, 75 = 60+15.
        card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_gain
        return {
          message = 'Upgraded!',
          colour = G.C.CHIPS,
          -- The return value, "card", is set to the variable "card", which is the joker.
          -- Basically, this tells the return value what it's affecting, which if it's the joker itself, it's usually card.
          -- It can be things like card = context.other_card in some cases, so specifying card (return value) = card (variable from function) is required.
          card = card
        }
      end
    end
  }
----------------------------------------------
------------MOD CODE END----------------------
    