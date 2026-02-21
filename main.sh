#!/bin/bash

# --- Configuration ---
DELAY=0.03
LONG_DELAY=1.5

# --- Game State ---
INVENTORY=()
HAS_KEY=false

# --- Helper Functions ---
typewriter() {
    local text="$1"
    for ((i=0; i<${#text}; i++)); do
        echo -n "${text:$i:1}"
        sleep "$DELAY"
    done
    echo ""
}

clear_screen() {
    clear
}

press_any_key() {
    echo -e "\n[ Press any key to continue ]"
    read -n 1 -s
}

add_to_inventory() {
    local item="$1"
    INVENTORY+=("$item")
    echo -e "\n>>> Added to inventory: $item <<<"
    sleep 1
}

show_inventory() {
    clear_screen
    echo "================================================================================"
    echo "                                  INVENTORY                                    "
    echo "================================================================================"
    if [ ${#INVENTORY[@]} -eq 0 ]; then
        echo "Your pockets are empty, save for some lint and the cold."
    else
        for item in "${INVENTORY[@]}"; do
            echo "- $item"
        done
    fi
    echo "================================================================================"
    press_any_key
}

# --- Game Scenes ---

start_game() {
    clear_screen
    typewriter "The rhythm of the rain is the only thing you hear..."
    sleep "$LONG_DELAY"
    typewriter "It's cold. A biting, unnatural cold that seeps into your marrow."
    sleep "$LONG_DELAY"
    typewriter "You open your eyes, but the world remains a blur of charcoal grey and slick obsidian."
    sleep "$LONG_DELAY"
    
    main_opening
}

main_opening() {
    clear_screen
    echo "================================================================================"
    echo "                              THE DAMP THRESHOLD                               "
    echo "================================================================================"
    typewriter "You are lying on cold, wet cobblestones. The rain falls in heavy, rhythmic"
    typewriter "sheets, masking the sounds of whatever might be lurking in the shadows."
    echo ""
    typewriter "Above you, a single rusted streetlamp flickers, its pale yellow light"
    typewriter "struggling against the oppressive darkness of the narrow alley."
    echo ""
    typewriter "To your left, a heavy iron door stands slightly ajar, a sliver of"
    typewriter "impenetrable blackness beckoning from within."
    echo ""
    typewriter "Ahead, the alleyway vanishes into a thick, swirling fog."
    echo ""
    
    echo "What do you do?"
    echo "1) Examine your surroundings"
    echo "2) Enter the iron door"
    echo "3) Walk into the fog"
    echo "4) Stay still and listen"
    echo "i) Check inventory"
    
    read -p "> " choice

    case $choice in
        1)
            examine_surroundings
            ;;
        2)
            enter_door
            ;;
        3)
            walk_into_fog
            ;;
        4)
            stay_still
            ;;
        i|I)
            show_inventory
            main_opening
            ;;
        *)
            typewriter "Indecision is a slow death. Choose wisely."
            sleep 1
            main_opening
            ;;
    esac
}

examine_surroundings() {
    clear_screen
    typewriter "You run your hands over the stones. They are slick with more than just rain."
    typewriter "A faint, metallic smell hangs in the air—old blood and stagnant water."
    
    if [ "$HAS_KEY" = false ]; then
        echo ""
        typewriter "Your fingers brush against something cold and hard wedged between the bricks."
        typewriter "It's a heavy, blood-stained key. The metal feels unnaturally warm."
        echo ""
        echo "Pick it up? (y/n)"
        read -p "> " pickup
        if [[ "$pickup" =~ ^[Yy]$ ]]; then
            add_to_inventory "Blood-stained Key"
            HAS_KEY=true
        else
            typewriter "You leave the key in the filth. Some things are better left untouched."
        fi
    else
        typewriter "In the dim light, you see deep gouges in the brick walls, as if something"
        typewriter "with very long claws was trying to climb... or drag something up."
    fi
    
    press_any_key
    main_opening
}

enter_door() {
    clear_screen
    typewriter "You approach the iron door. The air coming from the crack is freezing."
    
    if [ "$HAS_KEY" = true ]; then
        typewriter "You notice the door isn't just ajar; it's been forced."
        typewriter "The Blood-stained Key in your pocket pulses with a dull, rhythmic heat."
        typewriter "You push the door open. It creaks with a high-pitched wail."
        sleep "$LONG_DELAY"
        typewriter "As you step inside, the door slams shut. You hear the lock turn itself."
        typewriter "You are trapped."
    else
        typewriter "You try to push the door, but it feels heavy, resistant."
        typewriter "Without a way to defend yourself or light the way, the darkness"
        typewriter "inside feels like a physical weight, pushing you back."
        press_any_key
        main_opening
        return
    fi
    
    sleep "$LONG_DELAY"
    typewriter "Darkness swallows you whole."
    echo -e "\nTo be continued..."
    exit 0
}

walk_into_fog() {
    clear_screen
    typewriter "You step into the mist. It feels thick, almost like cobwebs against your skin."
    typewriter "The sound of the rain muffles instantly."
    typewriter "You hear a wet, dragging sound coming from right behind you..."
    sleep "$LONG_DELAY"
    typewriter "Something cold touches your neck."
    echo -e "\nTo be continued..."
    exit 0
}

stay_still() {
    clear_screen
    typewriter "You hold your breath. The world goes silent, save for the 'drip... drip... drip...'"
    sleep "$LONG_DELAY"
    typewriter "Then, a whisper, right in your ear:"
    typewriter "'...finally... you're awake...'"
    press_any_key
    main_opening
}

# --- Execution ---
chmod +x "$0"
start_game
