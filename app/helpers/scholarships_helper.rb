module ScholarshipsHelper
  def geographic_emojis
    {
      'united_kingdom' => '🇬🇧',
      'united_states' => '🇺🇸',
      'china' => '🇨🇳',
      'japan' => '🇯🇵',
      'ireland' => '🇮🇪',
      'germany' => '🇩🇪',
      'india' => '🇮🇳',
      'africa' => '🌍',
      'asia' => '🌏',
      'latin_america' => '🌎',
      'global' => '🌐'
    }
  end

  def field_emojis
    {
      'stem' => '🧑‍🔬',
      'medical' => '⚕️',
      'law' => '⚖️',
      'social_justice' => '🗽',
      'peace_studies' => '✌️',
      'security_studies' => '🛡',
      'financial' => '💰',
      'food_security' => '🥖',
      'music' => '🎵',
      'language' => '🗣'
    }
  end

  def get_emoji(tag)
    geographic_emojis[tag] || field_emojis[tag] || ''
  end
end 