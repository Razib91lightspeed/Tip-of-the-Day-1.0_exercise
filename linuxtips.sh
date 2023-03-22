#!/bin/bash

# Set the number of tips to show
NUM_TIPS=10

# Get the list of tip cards and store them in an array
TIP_CARDS=($(ls tip_cards))

# Shuffle the tip cards array
shuf -e "${TIP_CARDS[@]}" -o "${TIP_CARDS[@]}"

# Get the index of the last shown tip card from the configuration file
if [ -f ~/.linuxtips_config ]; then
  LAST_TIP_INDEX=$(head -n 1 ~/.linuxtips_config)
else
  LAST_TIP_INDEX=-1
fi

# Calculate the index of the next tip card to show
NEXT_TIP_INDEX=$((LAST_TIP_INDEX + 1))
if [ $NEXT_TIP_INDEX -ge ${#TIP_CARDS[@]} ]; then
  NEXT_TIP_INDEX=0
fi

# Get the path of the next tip card to show
NEXT_TIP_CARD="tip_cards/${TIP_CARDS[NEXT_TIP_INDEX]}"

# Show the next tip card
echo ""
cat $NEXT_TIP_CARD
echo ""

# Update the configuration file with the index of the last shown tip card
echo $NEXT_TIP_INDEX > ~/.linuxtips_config

# Prompt the user if they want to see more tips
if [ $NEXT_TIP_INDEX -eq $((NUM_TIPS - 1)) ]; then
  # Remove the configuration file to start over with the first tip card
  rm -f ~/.linuxtips_config
  echo "You have reached the end of the tips."
else
  read -p "Do you want to see more tips? (y/n) " SHOW_MORE
  if [ "$SHOW_MORE" == "y" ]; then
    # Re-run the script to show the next tip card
    source linuxtips.sh
  else
    echo "You have seen $NEXT_TIP_INDEX tips today."
  fi
fi

