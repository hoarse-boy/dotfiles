function my_fav_pokemon
    # Define an array of specific Pokémon names. if you want mega form for example do it like this: blaziken_-f_mega
    set POKEMONS blaziken blaziken_-f_mega blastoise blastoise_-f_mega nidoking_-s steelix_-f_mega aggron_-f_mega arcanine lucario_-f_mega

    # Get a random index
    set RANDOM_INDEX (math (random 1 (count $POKEMONS)))

    # Get the random Pokémon name
    set RANDOM_POKEMON (echo $POKEMONS | cut -d ' ' -f $RANDOM_INDEX)

    # Split the string by the underscore delimiter
    set POKEMON_NAME (string split '_' $RANDOM_POKEMON)

    # Display the random Pokémon
    pokemon-colorscripts -n $POKEMON_NAME --no-title
end
