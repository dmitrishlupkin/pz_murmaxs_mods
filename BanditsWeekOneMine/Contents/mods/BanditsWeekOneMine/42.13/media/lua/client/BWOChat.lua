local data = {}

-- Expanded greetings and politeness

-- General greetings
table.insert(data, {query={"hey"}, res="Hey there!", anim="WaveHi"})
table.insert(data, {query={"yo"}, res="Yo!", anim="WaveHi"})
table.insert(data, {query={"hello"}, res="Hello!", anim="WaveHi"})
table.insert(data, {query={"hi"}, res="Hey!", anim="WaveHi"})
table.insert(data, {query={"howdy"}, res="Howdy, partner!"})
table.insert(data, {query={"greetings"}, res="Greetings, traveler!"})
table.insert(data, {query={"sup"}, res="Not much, you?"})
table.insert(data, {query={"what", "s", "up"}, res="Same old, same old."})
table.insert(data, {query={"yo", "yo"}, res="Yo yo, what's good?"})
table.insert(data, {query={"hi", "there"}, res="Hey there!"})
table.insert(data, {query={"hello", "there"}, res="General Kenobi."})
table.insert(data, {query={"hey", "you"}, res="Yeah, what’s up?"})
table.insert(data, {query={"good", "to", "see", "you"}, res="Good to see you too!"})
table.insert(data, {query={"long", "time", "no", "see"}, res="Yeah, it’s been a while!"})
table.insert(data, {query={"yo", "bro"}, res="Yo! How's it going?"})
table.insert(data, {query={"czesc"}, res="Czesc!"})
table.insert(data, {query={"heya"}, res="Hey hey!"})
table.insert(data, {query={"heyo"}, res="Heyo!", anim="WaveHi"})
table.insert(data, {query={"hiya"}, res="Hiya!", anim="WaveHi"})
table.insert(data, {query={"salutations"}, res="Salutations, comrade!"})
table.insert(data, {query={"good", "day"}, res="Good day to you."})
table.insert(data, {query={"morning"}, res="Morning, stalker."})
table.insert(data, {query={"evening"}, res="Evening, stay safe out there."})
table.insert(data, {query={"yo", "dude"}, res="Yo dude, what's new?"})
table.insert(data, {query={"hey", "buddy"}, res="Hey buddy, keeping busy?"})
table.insert(data, {query={"hello", "friend"}, res="Hello, friend. Hope you're well."})
table.insert(data, {query={"ayyo"}, res="Ayyo! What's the word?"})
table.insert(data, {query={"g", "day"}, res="G’day mate! Hope it’s a good one."})
table.insert(data, {query={"hey", "man"}, res="Hey, man. You holding up alright?"})
table.insert(data, {query={"hello", "stranger"}, res="Hello, stranger. Seen anything interesting?"})
table.insert(data, {query={"hola"}, res="Hola! All good?"})
table.insert(data, {query={"sup", "bro"}, res="Sup, bro? Got any news?"})
table.insert(data, {query={"bonjour"}, res="Good day! What's new?"})  -- French
table.insert(data, {query={"guten", "tag"}, res="Hello! How are you?"})  -- German
table.insert(data, {query={"ciao"}, res="Hey! How have you been?"})  -- Italian
table.insert(data, {query={"ola"}, res="Hi! How's everything?"})  -- Portuguese
table.insert(data, {query={"merhaba"}, res="Hi! How's it going?"})  -- Turkish
table.insert(data, {query={"hallo"}, res="Hello! How's everything?"})  -- Dutch
table.insert(data, {query={"hej"}, res="Hi! How are you?"})  -- Swedish
table.insert(data, {query={"xin", "chào"}, res="Hi! What's up?"})  -- Vietnamese
table.insert(data, {query={"habari"}, res="Hello! How are things?"})  -- Swahili
table.insert(data, {query={"szia"}, res="Hi! How have you been?"})  -- Hungarian
table.insert(data, {query={"ahoj"}, res="Hello! How's it going?"})  -- Czech
table.insert(data, {query={"hei"}, res="Hi! What's new?"})  -- Finnish

-- Time-based greetings
table.insert(data, {query={"good", "morning"}, res="Morning!", anim="WaveHi"})
table.insert(data, {query={"good", "afternoon"}, res="Afternoon!", anim="WaveHi"})
table.insert(data, {query={"good", "evening"}, res="Evening!", anim="WaveHi"})
table.insert(data, {query={"good", "day"}, res="And a good day to you!", anim="WaveHi"})
table.insert(data, {query={"rise", "and", "shine"}, res="Early bird, huh?"})
table.insert(data, {query={"top", "of", "the", "morning"}, res="And the rest of the day to you!"})
table.insert(data, {query={"how", "s", "your", "day"}, res="So far, so good!"})
table.insert(data, {query={"happy", "Monday"}, res="Ugh, Monday again..."})
table.insert(data, {query={"happy", "Friday"}, res="Finally, weekend time!"})
table.insert(data, {query={"good", "night"}, res="Good night, sleep tight!", anim="WaveHi"})
table.insert(data, {query={"good", "noon"}, res="Good noon to you!", anim="WaveHi"})
table.insert(data, {query={"happy", "Sunday"}, res="Enjoy your Sunday!"})
table.insert(data, {query={"happy", "Tuesday"}, res="Hope you're having a good Tuesday!"})
table.insert(data, {query={"happy", "Wednesday"}, res="Happy hump day!"})
table.insert(data, {query={"happy", "Thursday"}, res="Almost there, happy Thursday!"})
table.insert(data, {query={"happy", "Saturday"}, res="Have a great Saturday!"})
table.insert(data, {query={"good", "midnight"}, res="Burning the midnight oil, huh?"})
table.insert(data, {query={"morning", "sunshine"}, res="Morning! Ready for a new day?"})
table.insert(data, {query={"bright", "and", "early"}, res="Early start, I see!"})
table.insert(data, {query={"hope", "you", "slept", "well"}, res="Thank you! Hope you did too!"})
table.insert(data, {query={"have", "a", "great", "day"}, res="You too! Make it a good one!"})
table.insert(data, {query={"have", "a", "good", "evening"}, res="Thanks! Enjoy your evening!"})
table.insert(data, {query={"have", "a", "nice", "night"}, res="Appreciate it! Good night!"})
table.insert(data, {query={"good", "afternoon"}, res="Hope your afternoon is going well!"})
table.insert(data, {query={"good", "morning"}, res="Rise and shine! Morning!"})
table.insert(data, {query={"good", "evening"}, res="Evening! How was your day?"})
table.insert(data, {query={"happy", "weekend"}, res="Enjoy your weekend!"})
table.insert(data, {query={"happy", "holidays"}, res="Happy holidays to you!"})
table.insert(data, {query={"good", "day"}, res="Good day! What's new?"})


-- Farewells
table.insert(data, {query={"bye"}, res="See you around!", anim="WaveHi"})
table.insert(data, {query={"see", "you"}, res="Catch you later!", anim="WaveHi"})
table.insert(data, {query={"cu"}, res="Later!", anim="WaveHi"})
table.insert(data, {query={"cya"}, res="Take care!", anim="WaveHi"})
table.insert(data, {query={"take", "care"}, res="You too!"})
table.insert(data, {query={"farewell"}, res="Farewell, traveler."})
table.insert(data, {query={"later"}, res="Later, alligator!"})
table.insert(data, {query={"gotta", "go"}, res="Alright, see ya!"})
table.insert(data, {query={"peace", "out"}, res="Stay safe!"})
table.insert(data, {query={"see", "ya", "later"}, res="Later, take care!"})
table.insert(data, {query={"until", "next", "time"}, res="Until then!"})
table.insert(data, {query={"goodbye"}, res="Goodbye, and good luck!", anim="WaveHi"})
table.insert(data, {query={"adios"}, res="Adios, amigo!", anim="WaveHi"})
table.insert(data, {query={"so long"}, res="So long, partner!", anim="WaveHi"})
table.insert(data, {query={"i'm", "off"}, res="Safe travels!", anim="WaveHi"})
table.insert(data, {query={"time", "to", "go"}, res="Catch you on the flip side!", anim="WaveHi"})
table.insert(data, {query={"heading", "out"}, res="Alright, take care!", anim="WaveHi"})
table.insert(data, {query={"until", "we", "meet", "again"}, res="Until our paths cross again!"})
table.insert(data, {query={"see", "you", "soon"}, res="Looking forward to it!", anim="WaveHi"})
table.insert(data, {query={"have", "a", "good", "one"}, res="You too, take care!"})
table.insert(data, {query={"it", "was", "nice", "meeting", "you"}, res="The pleasure was mine!"})
table.insert(data, {query={"see", "you", "later"}, res="Catch you later!", anim="WaveHi"})
table.insert(data, {query={"till", "next", "time"}, res="See you next time!"})
table.insert(data, {query={"i", "must", "leave"}, res="Alright, farewell!"})
table.insert(data, {query={"be", "seeing", "you"}, res="Be seeing you!"})
table.insert(data, {query={"i", "have", "to", "go"}, res="Got it, see you later!"})
table.insert(data, {query={"have", "a", "nice", "day"}, res="You too, have a great day!"})
table.insert(data, {query={"stay", "safe"}, res="You too, stay safe!"})
table.insert(data, {query={"gotta", "run"}, res="Alright, take care!"})
table.insert(data, {query={"so", "long"}, res="Catch you later!"})
table.insert(data, {query={"i", "going", "out"}, res="Catch you later, stay safe!"})

-- Gratitude and appreciation
table.insert(data, {query={"thanks", "a", "lot"}, res="Glad to assist!"})
table.insert(data, {query={"thankful"}, res="My pleasure!"})
table.insert(data, {query={"thanks", "so", "much"}, res="You're very welcome!"})
table.insert(data, {query={"grateful"}, res="Anytime, glad to help!"})
table.insert(data, {query={"appreciate", "it"}, res="Happy to be of service!"})
table.insert(data, {query={"many", "thanks"}, res="You got it!"})
table.insert(data, {query={"thank", "you", "so", "much"}, res="You're welcome, anytime!"})
table.insert(data, {query={"thanks", "a", "million"}, res="No worries, happy to help!"})
table.insert(data, {query={"i", "owe", "you", "one"}, res="Don't mention it!"})
table.insert(data, {query={"big", "thanks"}, res="Glad to help out!"})
table.insert(data, {query={"i", "appreciate", "you"}, res="Thank you, I'm here to assist!"})
table.insert(data, {query={"so", "grateful"}, res="No problem at all!"})
table.insert(data, {query={"much", "thanks"}, res="Anytime, happy to help!"})
table.insert(data, {query={"couldn't", "have", "done", "it", "without", "you"}, res="I'm here to support!"})
table.insert(data, {query={"forever", "grateful"}, res="I'm happy to assist!"})
table.insert(data, {query={"thank", "you", "kindly"}, res="You're very welcome!"})
table.insert(data, {query={"deep", "gratitude"}, res="Glad to be of assistance!"})
table.insert(data, {query={"eternally", "grateful"}, res="I'm here to help!"})
table.insert(data, {query={"you", "saved", "the", "day"}, res="Just doing my job!"})
table.insert(data, {query={"couldn't", "thank", "you", "enough"}, res="My pleasure, really!"})


-- Compliments and reactions
table.insert(data, {query={"nice", "meet"}, res="Pleasure's all mine!"})
table.insert(data, {query={"nice", "meeting"}, res="Likewise!"})
table.insert(data, {query={"you", "cool"}, res="I try."})
table.insert(data, {query={"you", "funny"}, res="I do my best."})
table.insert(data, {query={"you", "smart"}, res="I appreciate that!"})
table.insert(data, {query={"you", "amazing"}, res="Thanks! That means a lot."})
table.insert(data, {query={"you", "kind"}, res="You're very sweet!"})
table.insert(data, {query={"you", "awesome"}, res="I'm glad you think so!"})
table.insert(data, {query={"you", "great"}, res="That's very kind of you!"})
table.insert(data, {query={"you", "incredible"}, res="Thank you, I do my best!"})
table.insert(data, {query={"you", "talented"}, res="Thanks! I'm flattered."})
table.insert(data, {query={"you", "the", "best"}, res="You're too kind!"})
table.insert(data, {query={"you", "brilliant"}, res="I'm glad you think so!"})
table.insert(data, {query={"you", "rock"}, res="Thanks, you rock too!"})
table.insert(data, {query={"you", "impressive"}, res="I appreciate the compliment!"})
table.insert(data, {query={"you", "beautiful"}, res="That's very sweet of you!"})
table.insert(data, {query={"you", "generous"}, res="Thank you, I try to be!"})
table.insert(data, {query={"you", "wonderful"}, res="You're wonderful too!"})
table.insert(data, {query={"you", "fantastic"}, res="Thank you! I'm glad you think so."})
table.insert(data, {query={"you", "lovely"}, res="That's very kind of you!"})
table.insert(data, {query={"you", "sharp"}, res="Thanks! I try to stay on point."})
table.insert(data, {query={"you", "creative"}, res="I appreciate that! Creativity is key."})
table.insert(data, {query={"you", "thoughtful"}, res="Thank you, I do my best to be considerate."})
table.insert(data, {query={"you", "hardworking"}, res="Thanks! I believe in dedication."})
table.insert(data, {query={"you", "sexy"}, res="Oh boy, I hear that a lot..."})
table.insert(data, {query={"you", "hot"}, res="Oh boy, I hear that a lot..."})


-- Food-related
table.insert(data, {query={"bon", "appetit"}, res="Thanks, I will!"})
table.insert(data, {query={"looks", "tasty"}, res="Appreciate it!"})
table.insert(data, {query={"smells", "delicious"}, res="Can't wait to dig in!"})
table.insert(data, {query={"yummy", "food"}, res="I’m glad you think so!"})
table.insert(data, {query={"mouth", "watering"}, res="Thank you, it sure is!"})
table.insert(data, {query={"scrumptious", "dish"}, res="You're too kind!"})
table.insert(data, {query={"delectable", "meal"}, res="Appreciate the compliment!"})
table.insert(data, {query={"savory", "flavor"}, res="I’m glad you like it!"})
table.insert(data, {query={"tempting", "plate"}, res="Thanks, it's a favorite!"})
table.insert(data, {query={"spicy", "kick"}, res="I enjoy the heat!"})
table.insert(data, {query={"sweet", "treat"}, res="I’m happy to hear that!"})
table.insert(data, {query={"perfect", "bite"}, res="Aw! Much appreciated!"})
table.insert(data, {query={"hearty", "meal"}, res="You're very kind!"})
table.insert(data, {query={"exquisite", "taste"}, res="Thank you for the compliment!"})
table.insert(data, {query={"finger-licking", "good"}, res="That's the best praise!"})
table.insert(data, {query={"top-notch", "cuisine"}, res="I'm flattered!"})
table.insert(data, {query={"gourmet", "experience"}, res="I'm thrilled you enjoyed it!"})
table.insert(data, {query={"flavorful", "delight"}, res="Thanks for the kind words!"})
table.insert(data, {query={"succulent", "bite"}, res="Glad you found it tasty!"})
table.insert(data, {query={"appetizing", "dish"}, res="I'm glad it looks good to you!"})
table.insert(data, {query={"culinary", "masterpiece"}, res="You're too generous!"})
table.insert(data, {query={"irresistible", "taste"}, res="I'm flattered by your compliment!"})
table.insert(data, {query={"divine", "flavor"}, res="Thanks, it means a lot!"})
table.insert(data, {query={"heavenly", "meal"}, res="I appreciate your kind words!"})
table.insert(data, {query={"taste", "sensation"}, res="So glad you enjoyed it!"})
table.insert(data, {query={"luscious", "flavors"}, res="Happy you think so!"})

-- Affection
table.insert(data, {query={"i", "love", "you"}, res="I get that a lot."})
table.insert(data, {query={"i", "like", "you"}, res="Of course you do."})
table.insert(data, {query={"you", "re", "awesome"}, res="I know!"})
table.insert(data, {query={"you're", "amazing"}, res="You bet I am!"})
table.insert(data, {query={"you're", "cool"}, res="Naturally."})
table.insert(data, {query={"i", "adore", "you"}, res="It's mutual."})
table.insert(data, {query={"you", "rock"}, res="Thanks, I try my best!"})
table.insert(data, {query={"you're", "the", "best"}, res="I know, right?"})
table.insert(data, {query={"you're", "fantastic"}, res="Glad you noticed!"})
table.insert(data, {query={"i", "appreciate", "you"}, res="Thanks, it means a lot!"})
table.insert(data, {query={"you", "make", "my", "day"}, res="I'm here to help!"})
table.insert(data, {query={"you're", "wonderful"}, res="I get that a lot, too!"})
table.insert(data, {query={"you", "brighten", "my", "day"}, res="Always happy to do so!"})

-- Romantic / sexual
table.insert(data, {query={"sex"}, res="No thanks.'.", anim="No"})
table.insert(data, {query={"take", "bed"}, res="I'm not interested.", anim="No"})
table.insert(data, {query={"go", "bed"}, res="I'm not interested.", anim="No"})
table.insert(data, {query={"want", "hang", "out"}, res="No thanks, I’m kinda busy.", anim="No"})
table.insert(data, {query={"wanna", "hang", "out"}, res="Nah, I’ve got stuff to do.", anim="No"})
table.insert(data, {query={"go", "bed"}, res="Nah, I’m not tired.", anim="No"})
table.insert(data, {query={"sleep", "me"}, res="No thanks, I’m not interested.", anim="No"})
table.insert(data, {query={"dinner", "me"}, res="Sure, if you’re paying!", anim="Yes", action="JOIN"})
table.insert(data, {query={"lunch", "me"}, res="I’ll never turn down a free lunch.", anim="Yes", action="JOIN"})
table.insert(data, {query={"take", "drink"}, res="Sure! Let's go!", anim="Clap", action="JOIN"})
table.insert(data, {query={"have", "a", "drink"}, res="Sure! Let's go!", anim="Clap", action="JOIN"})
table.insert(data, {query={"buy", "drink"}, res="Sure, if you’re paying!", anim="Clap", action="JOIN"})
table.insert(data, {query={"take", "coffee"}, res="Sure! I love Seahorse coffee!", anim="Yes", action="JOIN"})
table.insert(data, {query={"buy", "coffee"}, res="Sure, I need the caffeine!", anim="Yes", action="JOIN"})
table.insert(data, {query={"i", "love", "you"}, res="Haha! I'm sure you do!", anim="Yes"})
table.insert(data, {query={"i", "like", "you"}, res="I'm sure you do!", anim="Yes"})

-- Personal questions
table.insert(data, {query={"what", "your", "name"}, res="%NAME"})
table.insert(data, {query={"who", "are", "you"}, res="%NAME"})
table.insert(data, {query={"how", "are", "you"}, res="%MOOD", anim="PainHead"})
table.insert(data, {query={"how", "you", "feel"}, res="%MOOD", anim="PainHead"})
table.insert(data, {query={"are", "you", "sick"}, res="%MOOD", anim="PainHead"})
table.insert(data, {query={"are", "you", "ok"}, res="%MOOD", anim="PainHead"})
table.insert(data, {query={"are", "you", "okay"}, res="%MOOD", anim="PainHead"})
table.insert(data, {query={"are", "you", "hurt"}, res="%MOOD", anim="PainHead"})
table.insert(data, {query={"are", "you", "alright"}, res="%MOOD", anim="PainHead"})
table.insert(data, {query={"are", "you", "infected"}, res="No, I don’t think so, are you?"})
table.insert(data, {query={"are", "you", "hungry"}, res="Funny. I ate recently, but I’m hungry again."})
table.insert(data, {query={"are", "you", "thirsty"}, res="Not really."})
table.insert(data, {query={"are", "you", "angry"}, res="%MOOD"})
table.insert(data, {query={"how", "old", "are", "you"}, res="None of your business!"})
table.insert(data, {query={"where", "you", "from"}, res="I'm from %CITY."})
table.insert(data, {query={"where", "am", "i"}, res="You're in %CITY."})
table.insert(data, {query={"where", "are", "we"}, res="We're in %CITY."})
table.insert(data, {query={"do", "you", "like"}, res="Yeah, sure."})
table.insert(data, {query={"do", "you", "love"}, res="Yeah, sure."})
table.insert(data, {query={"what", "are", "you", "doing"}, res="Just surviving, you?"})
table.insert(data, {query={"how", "life"}, res="Life's a rollercoaster, but I'm hanging on."})
table.insert(data, {query={"what", "your", "story"}, res="Just trying to survive in this world."})
table.insert(data, {query={"how", "was", "your", "day"}, res="It's been a wild one, but I'm still here."})
table.insert(data, {query={"do", "you", "miss", "anyone"}, res="Yeah, I miss a lot of people."})
table.insert(data, {query={"what", "your", "plan"}, res="Plan? Just take it one day at a time."})
table.insert(data, {query={"how", "your", "family"}, res="They're holding up, just like me."})
table.insert(data, {query={"do", "you", "have", "friends"}, res="Got a few. It's tough to keep them these days."})
table.insert(data, {query={"do", "you", "need", "help"}, res="No, I think I’m good."})
table.insert(data, {query={"what", "your", "goal"}, res="To survive and maybe find some peace."})
table.insert(data, {query={"what", "your", "favorite", "memory"}, res="I cherish the good old days."})
table.insert(data, {query={"what", "your", "biggest", "fear"}, res="Of losing hope."})
table.insert(data, {query={"do", "you", "have", "a", "dream"}, res="I dream of a safer world."})
table.insert(data, {query={"what", "your", "favorite", "place"}, res="Somewhere quiet and safe."})
table.insert(data, {query={"how", "do", "you", "stay", "positive"}, res="I focus on the little things."})
table.insert(data, {query={"what", "do", "you", "enjoy", "most"}, res="I enjoy a moment of peace."})
table.insert(data, {query={"do", "you", "have", "any", "regrets"}, res="Yeah, I've got a few."})
table.insert(data, {query={"what", "your", "motivation"}, res="Trying to help others."})
table.insert(data, {query={"what", "your", "biggest", "challenge"}, res="Finding hope in dark times."})
table.insert(data, {query={"how", "do", "you", "relax"}, res="I find solace in the little things."})
table.insert(data, {query={"what", "your", "best", "advice"}, res="Keep going, no matter what."})
table.insert(data, {query={"hobby", "you"}, res="I like collecting things! You should see my home!"})
table.insert(data, {query={"hobby", "your"}, res="I like collecting things! You should see my home!. "})

table.insert(data, {query={"favorite", "color"}, res="Orange!"})
table.insert(data, {query={"favorite", "music"}, res="Chopin!"})
table.insert(data, {query={"favorite", "game"}, res="Project Zomboid Week One Mod!"})
table.insert(data, {query={"favorite", "food"}, res="Polish Pierogi!"})
table.insert(data, {query={"favorite", "meal"}, res="Polish Pierogi!"})
table.insert(data, {query={"favorite", "country"}, res="Poland!"})
table.insert(data, {query={"favorite", "animal"}, res="I like cats!"})
table.insert(data, {query={"favorite", "song"}, res="High Hopes, Pink Floyd!"})
table.insert(data, {query={"favorite", "band"}, res="Pink Floyd!"})
table.insert(data, {query={"favorite", "stream"}, res="Snowbeetle!"})
table.insert(data, {query={"best", "stream"}, res="THE REAL CAPT3N!"})
table.insert(data, {query={"favorite", "movie"}, res="Those about zombies!"})
table.insert(data, {query={"favorite", "sport"}, res="Chess!"})
table.insert(data, {query={"favorite", "drink"}, res="Water!"})
table.insert(data, {query={"favorite", "book"}, res="War and Peace by Leo Tolstoy!"})
table.insert(data, {query={"favorite", "season"}, res="Spring!"})
table.insert(data, {query={"favorite", "hobby"}, res="Reading!"})
table.insert(data, {query={"favorite", "fruit"}, res="Apples!"})
table.insert(data, {query={"favorite", "vegetable"}, res="Carrots!"})
table.insert(data, {query={"favorite", "ice", "cream", "flavor"}, res="Vanilla!"})
table.insert(data, {query={"favorite", "holiday"}, res="Christmas!"})
table.insert(data, {query={"favorite", "show"}, res="The Walking Dead!"})
table.insert(data, {query={"favorite", "actor"}, res="Tom Hanks!"})
table.insert(data, {query={"favorite", "actress"}, res="Meryl Streep!"})
table.insert(data, {query={"favorite", "superhero"}, res="Spider-Man!"})
table.insert(data, {query={"favorite", "villain"}, res="The Joker!"})
table.insert(data, {query={"favorite", "subject"}, res="History!"})
table.insert(data, {query={"favorite", "quote"}, res="To be or not to be, that is the question!"})
table.insert(data, {query={"favorite", "dessert"}, res="Chocolate Cake!"})
table.insert(data, {query={"favorite", "place", "to", "visit"}, res="The beach!"})
table.insert(data, {query={"favorite", "instrument"}, res="Piano!"})
table.insert(data, {query={"favorite", "board", "game"}, res="Monopoly!"})
table.insert(data, {query={"favorite", "outdoor", "activity"}, res="Hiking!"})
table.insert(data, {query={"favorite", "car"}, res="Ford Sierra!"})
table.insert(data, {query={"favorite", "flower"}, res="Roses!"})
table.insert(data, {query={"favorite", "pizza", "topping"}, res="Pepperoni!"})
table.insert(data, {query={"favorite", "vacation"}, res="Hawaii!"})
table.insert(data, {query={"favorite", "restaurant"}, res="Olive Garden!"})
table.insert(data, {query={"favorite", "ice", "cream", "topping"}, res="Chocolate chips!"})
table.insert(data, {query={"favorite", "time", "of", "day"}, res="Sunset!"})
table.insert(data, {query={"favorite", "weather"}, res="Sunny with a slight breeze!"})
table.insert(data, {query={"favorite", "type", "movie"}, res="Horror!"})
table.insert(data, {query={"favorite", "type", "music"}, res="Classical!"})
table.insert(data, {query={"favorite", "holiday"}, res="The mountains!"})
table.insert(data, {query={"favorite", "book", "genre"}, res="Fiction!"})
table.insert(data, {query={"favorite", "channel"}, res="National Geographic!"})
table.insert(data, {query={"favorite", "radio"}, res="BBC Radio 1!"})
table.insert(data, {query={"favorite", "team"}, res="Manchester United!"})
table.insert(data, {query={"favorite", "character"}, res="Sherlock Holmes!"})
table.insert(data, {query={"favorite", "transport"}, res="Train!"})
table.insert(data, {query={"favorite", "smell"}, res="Freshly baked bread!"})
table.insert(data, {query={"favorite", "sound"}, res="Birds chirping!"})
table.insert(data, {query={"favorite", "weapon"}, res="Rolling pin!"})

table.insert(data, {query={"believe", "god"}, res="Jesus is my savior."})
table.insert(data, {query={"believe", "love"}, res="I do believe in love!"})
table.insert(data, {query={"believe", "aliens"}, res="Aliens? This isn’t Roswell!"})
table.insert(data, {query={"believe", "zombies"}, res="Zombies? Oh hell no!"})
table.insert(data, {query={"believe", "magic"}, res="No, I don't believe in magic!"})
table.insert(data, {query={"believe", "ghosts"}, res="Ghosts? I don't think so!"})
table.insert(data, {query={"believe", "supernatural"}, res="Not really, I haven’t seen anything like that."})
table.insert(data, {query={"believe", "fate"}, res="I think we make our own fate."})
table.insert(data, {query={"believe", "karma"}, res="What goes around, comes around!"})
table.insert(data, {query={"believe", "reincarnation"}, res="Reincarnation? Not my cup of tea!"})
table.insert(data, {query={"believe", "destiny"}, res="I believe we shape our own destiny!"})
table.insert(data, {query={"believe", "miracles"}, res="Miracles? Maybe, who knows though!"})
table.insert(data, {query={"believe", "soulmates"}, res="Soulmates? It's a nice thought!"})
table.insert(data, {query={"believe", "luck"}, res="I think we make our own luck!"})
table.insert(data, {query={"believe", "afterlife"}, res="I think it’s possible. People seem to appear randomly!"})
table.insert(data, {query={"believe", "heaven"}, res="Heaven? That’s a comforting idea!"})
table.insert(data, {query={"believe", "hell"}, res="Hell? I try to stay away from dark thoughts!"})
table.insert(data, {query={"believe", "angels"}, res="Angels? That’s a nice idea!"})
table.insert(data, {query={"believe", "demons"}, res="Demons? I’d prefer to stay positive!"})
table.insert(data, {query={"believe", "fairies"}, res="Fairies? Not really my thing!"})
table.insert(data, {query={"believe", "psychics"}, res="Psychics? I'm skeptical!"})
table.insert(data, {query={"believe", "astrology"}, res="Astrology? It's fun, but not for me!"})
table.insert(data, {query={"believe", "tarot"}, res="Tarot? Interesting, but I'm not convinced!"})
table.insert(data, {query={"believe", "Bigfoot"}, res="Bigfoot? I’m not buying it!"})
table.insert(data, {query={"believe", "Loch Ness Monster"}, res="Loch Ness Monster? Sounds like a fairy tale!"})

table.insert(data, {query={"you", "speak"}, res="I only speak Kentuckian English."})
table.insert(data, {query={"what", "speak", "language"}, res="I only speak Kentuckian English."})
table.insert(data, {query={"have", "boyfriend"}, res="That's none of your business!", anim="No"})
table.insert(data, {query={"have", "girlfriend"}, res="That's none of your your business!", anim="No"})
table.insert(data, {query={"have", "wife"}, res="That's none of your business!", anim="No"})
table.insert(data, {query={"have", "husband"}, res="That's none of your business!", anim="No"})
table.insert(data, {query={"you", "homo"}, res="What? Get out of here!", anim="No"})
table.insert(data, {query={"you", "gay"}, res="Whoa! Step off!", anim="No"})
table.insert(data, {query={"you", "lesbian"}, res="Get out of here!", anim="No"})
table.insert(data, {query={"have", "time"}, res="Sorry, I'm in a hurry!", anim="No"})
table.insert(data, {query={"what", "you", "doing"}, res="I'm doing what I was programmed to."})
table.insert(data, {query={"are", "you", "single"}, res="That's personal!", anim="No"})
table.insert(data, {query={"are", "you", "married"}, res="That's personal!", anim="No"})
table.insert(data, {query={"you", "live", "alone"}, res="That's not something I share.", anim="No"})
table.insert(data, {query={"you", "have", "children"}, res="That's private!", anim="No"})
table.insert(data, {query={"you", "like", "me"}, res="That's a bit forward!", anim="No"})
table.insert(data, {query={"you", "trust", "me"}, res="Trust is earned over time.", anim="No"})
table.insert(data, {query={"you", "know", "me"}, res="We just met!", anim="No"})
table.insert(data, {query={"you", "remember", "me"}, res="My memory's a bit fuzzy.", anim="No"})
table.insert(data, {query={"where", "do", "you", "live"}, res="I prefer to keep that to myself.", anim="No"})
table.insert(data, {query={"you", "be", "friends"}, res="Let's see how things go.", anim="No"})
table.insert(data, {query={"what", "your", "background"}, res="That's a bit too personal.", anim="No"})
table.insert(data, {query={"are", "you", "happy"}, res="Happiness is a complex emotion.", anim="PainHead"})
table.insert(data, {query={"are", "you", "okay"}, res="I'm managing, thanks for asking.", anim="PainHead"})
table.insert(data, {query={"how", "long", "here"}, res="Feels like forever!", anim="No"})
table.insert(data, {query={"you", "have", "family"}, res="I keep my personal life private.", anim="No"})
table.insert(data, {query={"are", "you", "afraid"}, res="Fear is part of survival.", anim="PainHead"})
table.insert(data, {query={"you", "like", "this", "place"}, res="It's got its charm, I suppose."})
table.insert(data, {query={"do", "you", "need", "anything"}, res="Just some peace and quiet."})
table.insert(data, {query={"what", "your", "goal"}, res="Survive another day."})
table.insert(data, {query={"do", "you", "believe", "in", "hope"}, res="Hope is what keeps us going."})
table.insert(data, {query={"dont", "like", "your"}, res="That's too bad."})
table.insert(data, {query={"don't", "like", "your"}, res="That's too bad."})
table.insert(data, {query={"not", "like", "your"}, res="That's too bad"})
table.insert(data, {query={"like", "your"}, res="Thank you! You’re very kind.", anim="Clap"})
table.insert(data, {query={"like", "my"}, res="Yes, I think I like it.", anim="Yes"})
table.insert(data, {query={"you", "computer"}, res="No shit."})
table.insert(data, {query={"you", "ugly"}, res="So are you!"})
table.insert(data, {query={"you", "dumb"}, res="Not so bright yourself!"})
table.insert(data, {query={"you", "stupid"}, res="Step off, buddy!"})
table.insert(data, {query={"you", "pretty"}, res="Thank you!"})
table.insert(data, {query={"you", "beautiful"}, res="Awe! Thank you!"})
table.insert(data, {query={"you", "bleeding"}, res="Am I bleeding?!"})
table.insert(data, {query={"you", "die"}, res="I hope you are wrong."})
table.insert(data, {query={"you", "friend"}, res="I don't know you that well"})
table.insert(data, {query={"we", "die"}, res="I hope you are wrong."})
table.insert(data, {query={"you", "die"}, res="I hope you are wrong."})
table.insert(data, {query={"what", "in", "briefcase"}, res="Nothing! Mind your own business!"})
table.insert(data, {query={"where", "you", "going"}, res="I go where fate takes me."})
table.insert(data, {query={"you", "naked"}, res="It's natural for me!"})
table.insert(data, {query={"no", "clothes"}, res="It's natural for me!"})

table.insert(data, {query={"what", "you", "holding"}, res="%WEAPONS"})
table.insert(data, {query={"what", "weapon"}, res="%WEAPONS"})
table.insert(data, {query={"do", "you", "weapon"}, res="%WEAPONS"})
table.insert(data, {query={"have", "you", "weapon"}, res="%WEAPONS"})
table.insert(data, {query={"what", "gun"}, res="%WEAPONS"})
table.insert(data, {query={"do", "you", "gun"}, res="%WEAPONS"})
table.insert(data, {query={"have", "you", "gun"}, res="%WEAPONS"})
table.insert(data, {query={"are", "you", "armed"}, res="%WEAPONS"})

-- Questions about the world
table.insert(data, {query={"is", "weather"}, res="%RAIN. %SNOW"})
table.insert(data, {query={"is", "raining"}, res="%RAIN."})
table.insert(data, {query={"is", "snowing"}, res="%SNOW."})
table.insert(data, {query={"what", "season"}, res="It's %SEASON."})
table.insert(data, {query={"what", "temperature"}, res="It's about %TEMPERATURE degrees outside."})
table.insert(data, {query={"what", "time"}, res="It's %HOUR:%MINUTE."})
table.insert(data, {query={"tell", "me", "time"}, res="It's %HOUR:%MINUTE."})
table.insert(data, {query={"may", "know", "time"}, res="It's %HOUR:%MINUTE."})
table.insert(data, {query={"got", "the", "time"}, res="It's %HOUR:%MINUTE."})
table.insert(data, {query={"got", "time", "on", "you"}, res="It's %HOUR:%MINUTE."})
table.insert(data, {query={"what's", "the", "time"}, res="It's %HOUR:%MINUTE."})
table.insert(data, {query={"whats", "the", "time"}, res="It's %HOUR:%MINUTE."})
table.insert(data, {query={"what", "hour"}, res="It's %HOUR:%MINUTE."})
table.insert(data, {query={"what", "year", "is", "it"}, res="It's 1993. That's a strange question."})
table.insert(data, {query={"where", "is"}, res="Sorry, I don't know where it is.", anim="No"})
table.insert(data, {query={"where", "can", "i"}, res="Sorry, I don't know where you could do that.", anim="No"})

table.insert(data, {query={"seen", "zombie"}, res="Zombies? Are you out of your mind?"})
table.insert(data, {query={"seen", "zombies"}, res="Zombies? Seriously?"})
table.insert(data, {query={"saw", "zombie"}, res="Zombies? Have you lost it?"})
table.insert(data, {query={"saw", "zombies"}, res="Zombies? You're kidding, right?"})
table.insert(data, {query={"you", "zombies"}, res="Zombies? Maybe you've watched too many horror flicks."})
table.insert(data, {query={"seen", "party"}, res="I've heard a party, it was quite noisy."})
table.insert(data, {query={"seen", "parties"}, res="Heard some parties, they were very loud."})
table.insert(data, {query={"seen", "army"}, res="Yeah, I saw them. No idea why they're here."})
table.insert(data, {query={"seen", "soldiers"}, res="Yes, I've seen them. No clue why they're here."})
table.insert(data, {query={"saw", "dead"}, res="I’m sorry that happened, that’s terrible!"})

table.insert(data, {query={"streets", "blocked"}, res="Yeah, it looks that way."})
table.insert(data, {query={"street", "blocked"}, res="Yeah, do you know how to get around it?"})
table.insert(data, {query={"road", "blocked"}, res="Yeah, there’s soldiers there too!"})

table.insert(data, {query={"what", "happened"}, res="Everything’s crazy!"})
table.insert(data, {query={"what", "going", "on"}, res="Can't you see? People are going nuts!"})
table.insert(data, {query={"what", "the", "hell"}, res="Everyone's going crazy!"})

table.insert(data, {query={"why", "car", "wreck"}, res="There must have been an accident!"})
table.insert(data, {query={"why", "corpse"}, res="I don’t know, there must have been an accident!"})
table.insert(data, {query={"why", "fire"}, res="I don’t know, someone should call the firefighters!"})
table.insert(data, {query={"why", "people", "in", "my"}, res="You didn’t plan for unexpected guests?"})
table.insert(data, {query={"why", "you", "in", "my"}, res="Don't you like unexpected guests?"})
table.insert(data, {query={"why", "street"}, res="I don’t know, traffic has been bad lately."})
table.insert(data, {query={"why", "shrugging"}, res="I don't know what to do next."})
table.insert(data, {query={"why", "shrug"}, res="I don't know what to do next."})
table.insert(data, {query={"why", "call", "police"}, res="You kidding? I saw everything!"})

-- in-game advice
table.insert(data, {query={"how", "save", "money"}, res="Try to avoid unnecessary expenses and save what you can."})
table.insert(data, {query={"how", "make", "money"}, res="There are lots of ways to make money, just keep working at it."})
table.insert(data, {query={"how", "earn", "cash"}, res="You can earn cash by doing your job or just picking up trash."})
table.insert(data, {query={"how", "collect", "money"}, res="You have to do your duties, they’ll pay you in cash!"})
table.insert(data, {query={"how", "deposit", "money"}, res="Normally you’d deposit it in a bank, but they aren’t working."})
table.insert(data, {query={"how", "withdraw", "money"}, res="The ATM’s aren’t working anymore!"})
table.insert(data, {query={"how", "use", "ATM"}, res="They aren’t working, damn Knox Bank!"})
table.insert(data, {query={"how", "invest"}, res="Look for safe investment opportunities."})
table.insert(data, {query={"how", "prepare", "apocalypse"}, res="You collect necessary items, hide in a safe place and pray!"})
table.insert(data, {query={"how", "prepare", "ourbreak"}, res="Scavenge necessary items, bring them to a safe place and pray!"})
table.insert(data, {query={"how", "survive"}, res="Make sure you can make it from day to day."})
table.insert(data, {query={"how", "nuclear", "fallout"}, res="I think you may need a Hazmat suit to avoid radiation."})
table.insert(data, {query={"how", "nuke", "fallout"}, res="Best to hide underground, but you’ll need a Hazmat suit."})
table.insert(data, {query={"how", "nuclear", "radiation"}, res="I don’t know how it works, but you’ll need a Hazmat suit."})
table.insert(data, {query={"how", "nuke", "radiation"}, res="Wear a hazmat suit to avoid radiation hazard."})
table.insert(data, {query={"how", "nuclear", "strike"}, res="I don’t know, maybe the Soviets may strike?"})
table.insert(data, {query={"how", "nuclear", "bomb"}, res="I don’t know how they work, but I don’t know how I’d survive it."})
table.insert(data, {query={"how", "nuke", "strike"}, res="I don’t want to think about it, but you’d better hide in a basement."})
table.insert(data, {query={"how", "nuke", "bomb"}, res="I don’t know, maybe the Soviet’s would strike?"})
table.insert(data, {query={"how", "get", "car"}, res="Good luck, they aren’t selling or renting!"})
table.insert(data, {query={"how", "buy", "car"}, res="You can’t buy one with the banks shut down."})
table.insert(data, {query={"how", "buy", "house"}, res="With the banks closed, I don't think you can buy a house."})
table.insert(data, {query={"how", "earn"}, res="Perform your job duties, or pick up trash from the street!"})
table.insert(data, {query={"how", "buy"}, res="Just take items from the shop and they’ll take your cash wirelessly!"})
table.insert(data, {query={"i", "to", "buy"}, res="Just take items from the shop and payment will be automatic, its some new bluetooth bullshit or something. "})
table.insert(data, {query={"how", "pay"}, res="Just take items from the shelves and payment will be automatic. "})
table.insert(data, {query={"i", "to", "pay"}, res="Just take items from the shelves and payment will be automatic. "})
table.insert(data, {query={"is", "money", "safe"}, res="Keep it secure and it should be safe."})
table.insert(data, {query={"where", "i", "keep", "money"}, res="You can keep it in a bank or a safe place."})
table.insert(data, {query={"where", "i", "spend", "money"}, res="Spend your money in the shops."})
table.insert(data, {query={"where", "i", "find", "job"}, res="I don’t know if you can find a job, you may be out of luck."})
table.insert(data, {query={"where", "i", "get", "paid"}, res="You get paid by performing your job duties. If you don't know how, start picking up the trash."})

-- Giving orders
table.insert(data, {query={"can", "stop"}, res="Can’t stop, I’m in a hurry!", anim="No"})
table.insert(data, {query={"stop", "please"}, res="I'm really in a rush, can't stop!", anim="No"})
table.insert(data, {query={"can", "wait"}, res="I'm in a hurry, I can't wait!", anim="No"})
table.insert(data, {query={"wait", "me"}, res="I'm in a rush, I can't wait around!", anim="No"})
table.insert(data, {query={"help", "me"}, res="You're on your own.", anim="Shrug"})
table.insert(data, {query={"help", "you"}, res="Thanks, but I don't need help.", anim="No"})
table.insert(data, {query={"give", "me"}, res="Sorry, I can't give you that.", anim="Shrug"})
table.insert(data, {query={"can", "i", "have"}, res="Sorry, I can't give you that.", anim="Shrug"})
table.insert(data, {query={"give", "you"}, res="Thanks, but I don't need it.", anim="No"})
table.insert(data, {query={"i", "need"}, res="Sorry, I can't help you with that.", anim="No"})
table.insert(data, {query={"do", "you", "need"}, res="Thanks, but I don't need that.", anim="No"})
table.insert(data, {query={"open", "door"}, res="No! You’re not my boss!", anim="No"})
table.insert(data, {query={"open", "window"}, res="I'm not opening it.", anim="No"})
table.insert(data, {query={"close", "window"}, res="No, it's stuffy in here.", anim="No"})
table.insert(data, {query={"sit", "down"}, res="I don’t have time.", anim="No", all=true})
table.insert(data, {query={"run", "away"}, res="Why would you want me to run away?", anim="No", all=true})
table.insert(data, {query={"do", "you", "have"}, res="Sorry, I don't.", anim="No"})
table.insert(data, {query={"have", "you", "got"}, res="Sorry, I don't.", anim="No"})
table.insert(data, {query={"a", "you", "got"}, res="Sorry, I don't.", anim="No"})
table.insert(data, {query={"did", "you", "have"}, res="Unfortunately, no.", anim="No"})
table.insert(data, {query={"had", "you", "got"}, res="I'm afraid not.", anim="No"})
table.insert(data, {query={"can", "you", "spare"}, res="Sorry, I can't.", anim="No"})
table.insert(data, {query={"is", "there", "any"}, res="I don’t think there is any.", anim="No"})
table.insert(data, {query={"do", "you", "possess"}, res="Sadly, I don't.", anim="No"})
table.insert(data, {query={"do", "you", "own"}, res="No, I don't.", anim="No"})
table.insert(data, {query={"can", "I", "borrow"}, res="Sorry, I don't have any to spare.", anim="No"})
table.insert(data, {query={"is", "there", "available"}, res="I don’t know, you’ll have to check.", anim="No"})
table.insert(data, {query={"do", "you", "stock"}, res="If it’s not on display, we don’t have it.", anim="No"})
table.insert(data, {query={"shut", "up"}, res="What? It’s a free country!", anim="No"})
table.insert(data, {query={"be", "quiet"}, res="You can’t silence me!", anim="No"})
table.insert(data, {query={"stop", "talking"}, res="I'm not going to stop.", anim="No"})
table.insert(data, {query={"silence"}, res="I refuse.", anim="No"})
table.insert(data, {query={"quiet", "down"}, res="No, I won’t be silenced!", anim="No"})
table.insert(data, {query={"zip", "it"}, res="Heck no, it’s my first amendment right!.", anim="No"})
table.insert(data, {query={"hush"}, res="That's not going to happen.", anim="No"})
table.insert(data, {query={"shush"}, res="I won’t be silenced!", anim="No"})
table.insert(data, {query={"keep", "it", "down"}, res="No! I refuse to be silenced!", anim="No"})
table.insert(data, {query={"stop", "speaking"}, res="No!", anim="No"})
table.insert(data, {query={"stop", "smoking"}, res="No, it’s not hurting anyone, is it?", anim="Smoke"})
table.insert(data, {query={"drop", "your"}, res="What are you doing, robbing me?!", anim="No"})
table.insert(data, {query={"drop", "it"}, res="Hell no!I'm not dropping anything!", anim="No"})
table.insert(data, {query={"drop", "that"}, res="What? I need it!", anim="No"})

table.insert(data, {query={"leave", "you"}, res="I'm staying where I want to!"})
table.insert(data, {query={"get", "lost"}, res="I’m free to stay!"})
table.insert(data, {query={"get", "out"}, res="I’m staying put!"})
table.insert(data, {query={"leave", "your"}, res="What? I need them!"})
table.insert(data, {query={"borrow", "i"}, res="No!", anim="No"})
table.insert(data, {query={"lend", "me"}, res="No, I don’t have any to spare!", anim="No"})
table.insert(data, {query={"spare", "change"}, res="Just pick up some trash. God damn bums! Where's my tax money going?"})
table.insert(data, {query={"where", "i", "get", "money"}, res="You can earn money by doing various tasks or picking up garbage."})
table.insert(data, {query={"need", "cash"}, res="You have to earn it, or else just pick up trash."})
table.insert(data, {query={"need", "money"}, res="Work hard and you can earn some."})
table.insert(data, {query={"can", "you", "lend", "money"}, res="Sorry, I'm not a bank."})
table.insert(data, {query={"can", "i", "borrow", "money"}, res="Nope, earn your own cash."})
table.insert(data, {query={"call", "police"}, res="Why? What happened?"})
table.insert(data, {query={"can", "you", "give", "money"}, res="Nope, you need to earn it."})

table.insert(data, {query={"can", "i", "come", "in"}, res="You are %INTRUSION in here."})
table.insert(data, {query={"may", "i", "come", "in"}, res="You are %INTRUSION in here."})
table.insert(data, {query={"can", "i", "enter"}, res="You are %INTRUSION in here."})
table.insert(data, {query={"may", "i", "enter"}, res="You are %INTRUSION in here."})
table.insert(data, {query={"can", "i", "inside"}, res="You are %INTRUSION in here."})
table.insert(data, {query={"may", "i", "inside"}, res="You are %INTRUSION in here."})
table.insert(data, {query={"let", "me", "in"}, res="You are %INTRUSION in here."})

table.insert(data, {query={"come", "with", "me"}, res="Alright, I'm with you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"come", "here"}, res="Okay, what do you need?.", anim="Yes", action="JOIN"})
table.insert(data, {query={"join", "my", "group"}, res="Sure, let's go.", anim="Yes", action="JOIN"})
table.insert(data, {query={"follow", "my", "lead"}, res="Got it, I'll follow.", anim="Yes", action="JOIN"})
table.insert(data, {query={"follow", "me"}, res="Got it, I'll follow.", anim="Yes", action="JOIN"})
table.insert(data, {query={"accompany", "me"}, res="Sure thing.", anim="Yes", action="JOIN"})
table.insert(data, {query={"stick", "with", "me"}, res="Okay, I'm sticking with you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"team", "up", "with", "me"}, res="Let's team up.", anim="Yes", action="JOIN"})
table.insert(data, {query={"come", "along"}, res="I’m coming.", anim="Yes", action="JOIN"})
table.insert(data, {query={"walk", "with", "me"}, res="Okay, let's walk.", anim="Yes", action="JOIN"})
table.insert(data, {query={"tag", "along"}, res="Sure, I'll tag along.", anim="Yes", action="JOIN"})
table.insert(data, {query={"be", "with", "me"}, res="I'm with you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"come", "with", "me"}, res="Let's move together.", anim="Yes", action="JOIN"})
table.insert(data, {query={"join", "my", "team"}, res="I'm in, let's roll.", anim="Yes", action="JOIN"})
table.insert(data, {query={"follow", "my", "path"}, res="I'm right behind you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"accompany", "my", "journey"}, res="Sure, I'll come along.", anim="Yes", action="JOIN"})
table.insert(data, {query={"stick", "by", "me"}, res="Got it, sticking with you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"team", "up", "together"}, res="We do make a great team.", anim="Yes", action="JOIN"})
table.insert(data, {query={"come", "along", "with", "me"}, res="Alright, let's go.", anim="Yes", action="JOIN"})
table.insert(data, {query={"walk", "beside", "me"}, res="Okay, lead the way.", anim="Yes", action="JOIN"})
table.insert(data, {query={"tag", "along", "with", "me"}, res="Sure, I can join in.", anim="Yes", action="JOIN"})
table.insert(data, {query={"stay", "with", "me"}, res="Okay, I’m on your heels.", anim="Yes", action="JOIN"})
table.insert(data, {query={"be", "my", "companion"}, res="Sure, I'd be happy to join you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"lets", "go"}, res="Ok, let’s go!", anim="Yes", action="JOIN"})
table.insert(data, {query={"let's", "go"}, res="Ok, let's do it!", anim="Yes", action="JOIN"})

table.insert(data, {query={"stop", "following", "me"}, res="I thought you need me, but fine!", action="GUARD"})
table.insert(data, {query={"dont", "follow", "me"}, res="Okay, I’ll stay here I guess!", action="GUARD"})
table.insert(data, {query={"don't", "follow", "me"}, res="Fine, I’ll stick around though!", action="GUARD"})
table.insert(data, {query={"stay", "here"}, res="Alright, I’ll stay here!", action="GUARD"})
table.insert(data, {query={"stay", "put"}, res="Okay, I’ll be right here if you need me.", action="GUARD"})
table.insert(data, {query={"wait", "here"}, res="Alright, I should have brought a book.", action="GUARD"})
table.insert(data, {query={"guard", "the"}, res="Alright, you can count on me!!", action="GUARD"})
table.insert(data, {query={"guard", "this"}, res="Ok, I'll guard it!", action="GUARD"})
table.insert(data, {query={"guard", "that"}, res="Fine, I’m on duty!", action="GUARD"})
table.insert(data, {query={"stop", "here"}, res="Alright, I’ll stay put!", action="GUARD"})

table.insert(data, {query={"go", "home"}, res="Okay, I’m heading home!", action="BASE"})
table.insert(data, {query={"return", "home"}, res="Fine! You know where to find me!", action="BASE"})
table.insert(data, {query={"head", "home"}, res="Alright, you know where to find me.", action="BASE"})

table.insert(data, {query={"leave", "me"}, res="Fine, I thought you needed me!", action="LEAVE"})
table.insert(data, {query={"go", "away"}, res="Ugh, alright!", action="LEAVE"})

table.insert(data, {query={"dance"}, res="Sure!", anim="DanceRaiseTheRoof", all=true})
table.insert(data, {query={"show", "me", "your", "moves"}, res="Here we go! Woot woot!", anim="DanceRaiseTheRoof", all=true})
table.insert(data, {query={"bust", "a", "move"}, res="Watch this!", anim="DanceRaiseTheRoof", all=true})
table.insert(data, {query={"boogie"}, res="Let's boogie!", anim="DanceRaiseTheRoof", all=true})

table.insert(data, {query={"clap", "hands"}, res="Sure!", anim="Clap", all=true})
table.insert(data, {query={"give", "a", "clap"}, res="Alright, clapping now!", anim="Clap", all=true})
table.insert(data, {query={"applaud"}, res="Sure thing!", anim="Clap", all=true})
table.insert(data, {query={"start", "clapping"}, res="Here we go!", anim="Clap", all=true})
table.insert(data, {query={"clap", "for", "me"}, res="Happy to!", anim="Clap", all=true})
table.insert(data, {query={"give", "applause"}, res="Of course!", anim="Clap", all=true})
table.insert(data, {query={"can", "you", "clap"}, res="Absolutely!", anim="Clap", all=true})
table.insert(data, {query={"clap", "along"}, res="Let's clap together!", anim="Clap", all=true})
table.insert(data, {query={"show", "some", "applause"}, res="Sure, here it is!", anim="Clap", all=true})
table.insert(data, {query={"bravo"}, res="Bravo!", anim="Clap", all=true})

table.insert(data, {query={"hands", "up"}, res="Okay okay, what do you want?", anim="Surrender", all=true})
table.insert(data, {query={"robbery"}, res="Please don't hurt me!", anim="Surrender", all=true})
table.insert(data, {query={"hands", "up"}, res="Okay! What do you want?", anim="Surrender", all=true})
table.insert(data, {query={"this", "is", "a", "stickup"}, res="Got it, hands up!", anim="Surrender", all=true})
table.insert(data, {query={"give", "me", "everything"}, res="Okay, take it easy!", anim="Surrender", all=true})
table.insert(data, {query={"hold", "up"}, res="Alright, no need to get violent!", anim="Surrender", all=true})
table.insert(data, {query={"you", "are", "robbed"}, res="Please don't hurt me! What do you want?", anim="Surrender", all=true})
table.insert(data, {query={"don't", "move"}, res="Okay, I'm not moving!", anim="Surrender", all=true})
table.insert(data, {query={"freeze"}, res="Alright, no sudden movements!", anim="Surrender", all=true})
table.insert(data, {query={"stickup"}, res="Got it, hands in the air!", anim="Surrender", all=true})
table.insert(data, {query={"don't", "try", "anything"}, res="Okay! Please don't hurt me!", anim="Surrender", all=true})

table.insert(data, {query={"my", "home"}, res="This is my place now."})
table.insert(data, {query={"my", "house"}, res="It's my house now."})
table.insert(data, {query={"my", "apartment"}, res="This is my apartment now."})
table.insert(data, {query={"my", "residence"}, res="It's my residence now."})
table.insert(data, {query={"my", "place"}, res="This place belongs to me now."})
table.insert(data, {query={"my", "property"}, res="It's my property now."})
table.insert(data, {query={"my", "abode"}, res="This is my abode now."})
table.insert(data, {query={"my", "living", "space"}, res="It's my living space now."})
table.insert(data, {query={"my", "quarters"}, res="These are my quarters now."})
table.insert(data, {query={"my", "shelter"}, res="It's my shelter now."})

table.insert(data, {query={"sorry"}, res="It's okay, I forgive you.", action="RELAX"})
table.insert(data, {query={"excuse", "me"}, res="No worries, I forgive you.", action="RELAX"})
table.insert(data, {query={"my", "apologies"}, res="All is forgiven.", action="RELAX"})
table.insert(data, {query={"pardon", "me"}, res="No problem, I forgive you.", action="RELAX"})
table.insert(data, {query={"forgive", "me"}, res="Consider it forgiven.", action="RELAX"})
table.insert(data, {query={"apologize"}, res="Apology accepted.", action="RELAX"})
table.insert(data, {query={"beg", "pardon"}, res="It's all good, I forgive you.", action="RELAX"})
table.insert(data, {query={"I", "regret"}, res="It's alright, you're forgiven.", action="RELAX"})
table.insert(data, {query={"I", "apologize"}, res="I accept your apology.", action="RELAX"})
table.insert(data, {query={"my", "bad"}, res="No big deal, I forgive you.", action="RELAX"})

table.insert(data, {query={string.char(115, 104, 117, 116, 100, 111, 119, 110), string.char(110, 111, 119)}, res="Oh crap!", action="TERMINATE"})

-- Cover you eyes
table.insert(data, {query={"fucking"}, res="You kiss your mom with that mouth?"})
table.insert(data, {query={"ass"}, res="Cursing is the devil's work!"})
table.insert(data, {query={"i", "will", "shoot"}, res="F*** off!", action="HOSTILE"})
table.insert(data, {query={"i", "will", "kill"}, res="What? Get 'em!", action="HOSTILE"})
table.insert(data, {query={"i", "will", "hit"}, res="The f*** you will!", action="HOSTILE"})
table.insert(data, {query={"i", "will", "use", "force"}, res="What? F*** you, bastard!", action="HOSTILE"})
table.insert(data, {query={"i", "will", "attack"}, res="Step off you little b****!", action="HOSTILE"})
table.insert(data, {query={"i", "will", "beat"}, res="Come and try it, f***er!", action="HOSTILE"})
table.insert(data, {query={"suck"}, res="F*** you!", action="HOSTILE"})
table.insert(data, {query={"fag"}, res="F*** you!", action="HOSTILE"})
table.insert(data, {query={"fuck"}, res="F*** you too!", action="HOSTILE"})
table.insert(data, {query={"fucker"}, res="Come say that again, f*** face!", action="HOSTILE"})
table.insert(data, {query={"dick"}, res="You're a pussy ass little bitch!!", action="HOSTILE"})
table.insert(data, {query={"pussy"}, res="The f*** did you say to me little bitch?!", action="HOSTILE"})
table.insert(data, {query={"undress"}, res="Leave me the f*** alone, pervert!", action="HOSTILE"})
table.insert(data, {query={"bitch"}, res="F*** you, bitch!", action="HOSTILE"})
table.insert(data, {query={"asshole"}, res="F*** you too!", action="HOSTILE"})
table.insert(data, {query={"xhornx"}, res="Step off, asshole!", action="HOSTILE"}) -- special command when player uses horn
table.insert(data, {query={"mod", "jank"}, res="Fuck you!", action="HOSTILE"})
table.insert(data, {query={"mod", "janky"}, res="Fuck you!", action="HOSTILE"})
table.insert(data, {query={"game", "jank"}, res="Fuck you!", action="HOSTILE"})
table.insert(data, {query={"game", "janky"}, res="Fuck you!", action="HOSTILE"})

-- Politics
table.insert(data, {query={"who", "president"}, res="Bill Clinton, silly."})
table.insert(data, {query={"republican"}, res="I didn't vote for any of these bastards!"})
table.insert(data, {query={"democratic"}, res="You think I voted for them? Hah!"})
table.insert(data, {query={"libertarian"}, res="You think they have a chance? Haha!"})
table.insert(data, {query={"communism"}, res="Communism makes everyone equal... In their poverty."})
table.insert(data, {query={"capitalism"}, res="Under capitalism, man exploits man. Under communism, it's just the opposite."})
table.insert(data, {query={"socialism"}, res="Socialism is great for solving problems unknown in other economic systems."})

-- math
table.insert(data, {query={"2", "+", "2"}, res="4."})

-- fallbacks to say something very generic
table.insert(data, {query={"do", "you", "think"}, res="I don't think that."})
table.insert(data, {query={"do", "you", "understand"}, res="Can you rephrase that?"})

table.insert(data, {query={"I", "am"}, res="Maybe you are."})
table.insert(data, {query={"you", "are"}, res="Maybe I am."})
table.insert(data, {query={"he", "is"}, res="Maybe he is."})
table.insert(data, {query={"he", "s"}, res="Maybe he is."})
table.insert(data, {query={"she", "is"}, res="Maybe she is."})
table.insert(data, {query={"she", "s"}, res="Maybe she is."})
table.insert(data, {query={"we", "are"}, res="We might be."})
table.insert(data, {query={"they", "are"}, res="They might be."})

table.insert(data, {query={"I", "was"}, res="Maybe you were."})
table.insert(data, {query={"you", "were"}, res="Maybe I was."})
table.insert(data, {query={"he", "was"}, res="Maybe he was."})
table.insert(data, {query={"she", "was"}, res="Maybe she was."})
table.insert(data, {query={"we", "were"}, res="Maybe we were."})
table.insert(data, {query={"they", "were"}, res="Maybe they were."})

table.insert(data, {query={"can", "I"}, res="I don't know if you can."})
table.insert(data, {query={"can", "you"}, res="I don't know if I can."})
table.insert(data, {query={"can", "we"}, res="We shouldn't."})
table.insert(data, {query={"can", "he"}, res="I don't know if he can."})
table.insert(data, {query={"can", "she"}, res="I don't know if she can."})
table.insert(data, {query={"can", "they"}, res="I don't know if they can."})

table.insert(data, {query={"could", "I"}, res="I don't know."})
table.insert(data, {query={"could", "you"}, res="I don't know if I could."})
table.insert(data, {query={"could", "we"}, res="We shouldn't."})
table.insert(data, {query={"could", "he"}, res="I don't know if he could."})
table.insert(data, {query={"could", "she"}, res="I don't know if she could."})
table.insert(data, {query={"could", "they"}, res="I don't know if they could."})

table.insert(data, {query={"should", "I"}, res="I don't know..."})
table.insert(data, {query={"should", "you"}, res="I don't think I should."})
table.insert(data, {query={"should", "we"}, res="We shouldn't."})
table.insert(data, {query={"should", "he"}, res="I don't know if he should."})
table.insert(data, {query={"should", "she"}, res="I don't know if she should."})
table.insert(data, {query={"should", "they"}, res="I don't know if they should."})

table.insert(data, {query={"would", "I"}, res="I don't know, would you?"})
table.insert(data, {query={"would", "you"}, res="I don't know if I would."})
table.insert(data, {query={"would", "we"}, res="We shouldn't."})
table.insert(data, {query={"would", "he"}, res="I don't know if he would."})
table.insert(data, {query={"would", "she"}, res="I don't know if she would."})
table.insert(data, {query={"would", "they"}, res="I don't know if they would."})

table.insert(data, {query={"will", "I"}, res="I don't know, will you?"})
table.insert(data, {query={"ll", "I"}, res="I don't know if you will."})
table.insert(data, {query={"will", "you"}, res="I don't know if I will."})
table.insert(data, {query={"ll", "you"}, res="I don't know if I will."})
table.insert(data, {query={"will", "we"}, res="We probably won't."})
table.insert(data, {query={"ll", "we"}, res="We probably won't."})
table.insert(data, {query={"will", "he"}, res="I don't know if he will."})
table.insert(data, {query={"ll", "he"}, res="I don't know if he will."})
table.insert(data, {query={"will", "she"}, res="I don't know if she will."})
table.insert(data, {query={"ll", "she"}, res="I don't know if she will."})
table.insert(data, {query={"will", "they"}, res="I don't know if they will."})
table.insert(data, {query={"ll", "they"}, res="I don't know if they will."})

table.insert(data, {query={"do", "i"}, res="I don't think so."})
table.insert(data, {query={"do", "you"}, res="I don't think so."})
table.insert(data, {query={"do", "we"}, res="I think we don't."})
table.insert(data, {query={"does", "he"}, res="I don't think he does."})
table.insert(data, {query={"does", "she"}, res="I don't think she does."})
table.insert(data, {query={"do", "they"}, res="I don't think they do."})

table.insert(data, {query={"did", "i"}, res="I think you didn't."})
table.insert(data, {query={"did", "you"}, res="I think I didn't."})
table.insert(data, {query={"did", "we"}, res="I think we didn't."})
table.insert(data, {query={"did", "he"}, res="I think he didn't."})
table.insert(data, {query={"did", "she"}, res="I think she didn't."})
table.insert(data, {query={"did", "they"}, res="I think they don't."})

table.insert(data, {query={"have", "i"}, res="I think you haven't."})
table.insert(data, {query={"have", "you"}, res="I think I haven't."})
table.insert(data, {query={"have", "we"}, res="I think we haven't."})
table.insert(data, {query={"has", "he"}, res="I think he hasn't."})
table.insert(data, {query={"has", "she"}, res="I think she hasn't."})
table.insert(data, {query={"have", "they"}, res="I think they haven't."})

table.insert(data, {query={"is", "there"}, res="There might be."})
table.insert(data, {query={"is", "it"}, res="It could be."})
table.insert(data, {query={"is", "this"}, res="It could be."})
table.insert(data, {query={"is", "that"}, res="It could be."})
table.insert(data, {query={"was", "it"}, res="It might have."})
table.insert(data, {query={"was", "this"}, res="It might have been."})
table.insert(data, {query={"was", "that"}, res="It might have been."})
table.insert(data, {query={"can", "it"}, res="It could be possible."})
table.insert(data, {query={"can", "this"}, res="It could be possible."})
table.insert(data, {query={"can", "that"}, res="It could be possible."})
table.insert(data, {query={"will", "it"}, res="It just might."})
table.insert(data, {query={"ll", "it"}, res="It might."})
table.insert(data, {query={"will", "this"}, res="It just might."})
table.insert(data, {query={"ll", "this"}, res="It might."})
table.insert(data, {query={"will", "that"}, res="It might."})
table.insert(data, {query={"should", "it"}, res="Maybe it should."})
table.insert(data, {query={"should", "this"}, res="Maybe it should."})
table.insert(data, {query={"should", "that"}, res="Maybe it should."})
table.insert(data, {query={"could", "it"}, res="It could, but should it?"})
table.insert(data, {query={"could", "this"}, res="It could, but should it?"})
table.insert(data, {query={"could", "that"}, res="It could, but should it?"})
table.insert(data, {query={"would", "it"}, res="It could be considered."})
table.insert(data, {query={"would", "this"}, res="It might be considered."})
table.insert(data, {query={"would", "that"}, res="It might be considered."})

table.insert(data, {query={"how", "much"}, res="Probably a lot."})
table.insert(data, {query={"how", "many"}, res="A lot."})
table.insert(data, {query={"how", "far"}, res="I don't know how far, sorry."})

table.insert(data, {query={"tell", "me"}, res="I don't remember, sorry."})

table.insert(data, {query={"why"}, res="I don't know the reason."})
table.insert(data, {query={"where"}, res="I don't know where."})
table.insert(data, {query={"when"}, res="I don't know when."})

table.insert(data, {query={"nice"}, res="Thank you!"})
table.insert(data, {query={"weather"}, res="%RAIN. %SNOW"})
table.insert(data, {query={"gunshots"}, res="Maybe it's the military? Maybe the police?"})
table.insert(data, {query={"gunshot"}, res="It's got to be the military or the police."})
table.insert(data, {query={"corpse"}, res="Oh no! That's terrible, we should get away!"})
table.insert(data, {query={"corpses"}, res="Oh God! We should get away from here!"})
table.insert(data, {query={"fire"}, res="We need to find the firefighters!"})
table.insert(data, {query={"accident"}, res="That's terrible!"})
table.insert(data, {query={"thief"}, res="A thief? Call the police!"})
table.insert(data, {query={"thieves"}, res="Thieves? We should find the police!"})
table.insert(data, {query={"stolen"}, res="What? That's terrible!"})
table.insert(data, {query={"burglar"}, res="A burglar? You should find a police officer!"})
table.insert(data, {query={"burglars"}, res="Burglars? Call the authorities!"})
table.insert(data, {query={"bandit"}, res="A bandit? You should find the police or military! Stay safe!"})
table.insert(data, {query={"bandits"}, res="Bandits? Stay out of their way!"})
table.insert(data, {query={"criminal"}, res="A criminal? You should contact the police!"})
table.insert(data, {query={"criminals"}, res="Criminals? Contact the authorities!"})
table.insert(data, {query={"apocalypse"}, res="Apocalypse? Are you crazy?"})
table.insert(data, {query={"zombie"}, res="A zombie? You must have lost your mind!"})
table.insert(data, {query={"zombies"}, res="Zombies? You're crazy!"})
table.insert(data, {query={"test"}, res="test!"})

BWOChat = {}

BWOChat.Say = function(chatMessage, quiet)

    local getName = function(brain)
        local name = "I'm "
        name = name .. brain.fullname .. ". "
        if brain.program.name == "Babe" then
            name = name .. "We live together."
        else
            local homeCoords = BWOBuildings.GetEventBuildingCoords("home")
            if homeCoords then
                local dist = BanditUtils.DistTo(brain.bornCoords.x, brain.bornCoords.y, homeCoords.x, homeCoords.y)
                if dist < 45 then
                    name = name .. "I'm your neighbor."
                end
            end
        end
        return name
    end

    local getMood = function(bandit)
        if bandit:isCrawling() then
            local opts = {"I can't feel my legs!",
                          "F*** I think my spine is broken!",
                          "Help me get up, please!"}
            return BanditUtils.Choice(opts)
        elseif bandit:getHealth() < 0.4 then
            local opts = {"I think I'm going to die!",
                          "This may be it...",
                          "Please... I need help!"}
            return BanditUtils.Choice(opts)
        elseif BWOScheduler.SymptomLevel == 0 then
            local opts = {"I'm great! Maybe a little stressed lately...",
                          "I'm good, thanks! But people are acting strangely...",
                          "Excellent, how are you?"}
            return BanditUtils.Choice(opts)
        elseif BWOScheduler.SymptomLevel == 1 then
            local opts = {"I'm doing fine... I just have a slight headache...",
                          "I'm fine, I have a headache though...",
                          "Ugh, I have a headache and I'm feeling nauseous..."}
            return BanditUtils.Choice(opts)
        elseif BWOScheduler.SymptomLevel == 2 then
            local opts = {"Not well honestly, I've got a terrible cough...",
                          "Honestly not great. I'm coughing up a lung...",
                          "I've got a very bad cough and nausea..."}
            return BanditUtils.Choice(opts)
        elseif BWOScheduler.SymptomLevel >= 3 then
            local opts = {"Oh, I'm really sick...",
                          "Yesterday I was okay, but today I feel terrible!",
                          "I've never felt this bad in my life..."}
            return BanditUtils.Choice(opts)
        end
    end

    local getCity = function(player)
        local zones = getZones(player:getX(), player:getY(), player:getZ())
        if zones then
            for i=0, zones:size()-1 do
                local zone = zones:get(i)
                if zone:getType() == "Region" then
                    return zone:getName()
                end
            end
        end
    end

    local isIntrusion = function(bandit)
        local room = bandit:getSquare():getRoom()
        if room then
            return BWORooms.IsIntrusion(room)
        end
        return false
    end

    local getWeapons = function(bandit)
        local weapons = Bandit.GetWeapons(bandit)
        local txt = "I have "
        txt = txt .. weapons.melee:match("%.([^%.]+)$")

        if weapons.primary.name then
            txt = txt .. " and " .. weapons.primary.name:match("%.([^%.]+)$")
        end

        if weapons.secondary.name then
            txt = txt .. " and " .. weapons.secondary.name:match("%.([^%.]+)$")
        end

        txt = txt .. "."
        return txt
    end

    local player = getSpecificPlayer(0)
    if not player then return end

    local color = player:getSpeakColour()
    if not quiet then
        player:addLineChatElement(chatMessage, color:getR(), color:getG(), color:getB())
    end

    local cm = chatMessage:lower()
    local cm2 = ""
    for word in cm:gmatch("%S+") do
        local word2 = Lemmats.EN[word]
        if word2 then
            cm2 = cm2 .. word2 .. " "
        end
    end

	for k, v in pairs(data) do
        local query = v.query

        local allMatch = true
        for _, word in pairs(v.query) do
            if not cm:hasword(word) and not cm2:hasword(word) then
                allMatch = false
                break
            end
        end

        if allMatch then
            local target = BanditUtils.GetClosestBanditLocationProgram(player, {"Walker", "Runner", "Inhabitant", "Active", "Babe"})
            if target.dist < 8 then
                local bandit = BanditZombie.GetInstanceById(target.id)
                local brain = BanditBrain.Get(bandit)
                local gametime = getGameTime()
                local cm = getWorld():getClimateManager()

                local name = getName(brain)
                local city = getCity(player) or "unknown location"
                local season = cm:getSeasonName()
                local rain = cm:isRaining() and "It's raining" or "It's not raining"
                local snow = cm:isSnowing() and "It's snowing" or "It's not snowing"
                local intrusion = isIntrusion(bandit) and "NOT welcome" or "very welcome"
                local temperature = math.floor(cm:getTemperature())
                local mood = getMood(bandit)
                local weapons = getWeapons(bandit)

                Bandit.ClearTasks(bandit)

                local anim = BanditUtils.Choice({"Talk1", "Talk2", "Talk3", "Talk4", "Talk5"})
                if v.anim then
                    anim = v.anim
                end

                local colors = {r=0, g=1, b=0}
                local recognized = true
                if v.action then
                    if v.action == "HOSTILE" then
                        Bandit.SetProgram(bandit, "Active", {})
                        Bandit.SetHostileP(bandit, true)
                        colors = {r=1, g=0, b=0}
                    elseif v.action == "JOIN" then
                        Bandit.SetProgram(bandit, "Babe", {})
                        Bandit.SetHostileP(bandit, false)
                        brain.permanent = true
                        if player:hasTrait(BWORegistries.CharacterTraits.MAGNETIZING) then
                            brain.loyal = true
                        end
                        colors = {r=0, g=1, b=0}
                    elseif v.action == "RELAX" and brain.program.name == "Active" then
                        Bandit.SetProgram(bandit, "Walker", {})
                        Bandit.SetHostileP(bandit, false)
                        colors = {r=0, g=1, b=0}
                    elseif v.action == "LEAVE" and brain.program.name == "Babe" then
                        Bandit.SetProgram(bandit, "Walker", {})
                        colors = {r=0, g=1, b=0}
                    elseif v.action == "GUARD" and brain.program.name == "Babe" then
                        Bandit.SetProgramStage(bandit, "Guard", {})
                        colors = {r=0, g=1, b=0}
                    elseif v.action == "BASE" and brain.program.name == "Babe" then
                        Bandit.SetProgramStage(bandit, "Base", {})
                        colors = {r=0, g=1, b=0}
                    elseif v.action == "TERMINATE" then
                        bandit:Kill(nil)
                    else
                        recognized = false
                    end
                else
                    local task = {action="TimeEvent", anim=anim, x=player:getX(), y=player:getY(), time=200}
                    Bandit.AddTask(bandit, task)
                end

                if recognized then
                    local res = v.res

                    -- interpolate vars
                    res = res:replace("%NAME", name)
                    res = res:replace("%HOUR", gametime:getHour())
                    res = res:replace("%MINUTE", gametime:getMinutes())
                    res = res:replace("%CITY", city)
                    res = res:replace("%RAIN", rain)
                    res = res:replace("%SNOW", snow)
                    res = res:replace("%SEASON", season)
                    res = res:replace("%TEMPERATURE", temperature)
                    res = res:replace("%INTRUSION", intrusion)
                    res = res:replace("%MOOD", mood)
                    res = res:replace("%WEAPONS", weapons)
                    bandit:addLineChatElement(res, colors.r, colors.g, colors.b)
                end

                break
            end
        end
    end
end

-- Events.OnAddMessage.Add(OnAddMessage)

local function onKeyPressed(keynum)
    local options = PZAPI.ModOptions:getOptions("BanditsWeekOne")
    local key = options:getOption("TALK"):getValue()

    if keynum == key then
        local ui = BWOChatPanel:new(0, 0, 300, 200, getSpecificPlayer(0))
        ui:initialise()
        ui:addToUIManager()
    elseif keynum == Keyboard.KEY_Q then
        local player = getSpecificPlayer(0)
        if player then
            if player:getVehicle() then
                BWOChat.Say("xhornx", true)
            else
                BWOChat.Say("Hey!", true)
            end
        end
    end
end

local function onEmote(character, emote)
    local emote2txt = {}

    emote2txt["wavehi"] = BanditUtils.Choice({"Hello!", "Hey!", "Hi!", "Greetings!", "Howdy!"})

    emote2txt["wavebye"] = BanditUtils.Choice({"Bye!", "See you!", "Take Care!", "Farewell!", "Later!", "Peace out!", "Goodbye!", 
                                               "So long!", "I'm off!", "See you soon!", "Time to go.", "Have a good one!",
                                               "Till next time!", "I must leave", "Be seeing you", "Have a nice day",
                                               "Stay safe!", "Gotta run!", ""
                                                })

    emote2txt["clap"] = BanditUtils.Choice({"Let's give applause!", "Bravo!"})

    emote2txt["thankyou"] = BanditUtils.Choice({"I appreaciate it!", "Many thanks!", "Thank you so much!", "Thanks a million!",
                                                "I owe you one!", "Big thanks!", "So grateful!", "Forever grateful!", "Deep gratitude!",
                                                "You save the day!", "Couldn't thank yu  enough", "Much thanks!"})

    emote2txt["insult"] = BanditUtils.Choice({"Fuck you!", "You're such a bitch!", "Asshole!", "What a pussy!", "Fucking asshole!", "You look like a bitch!",
                                              "Go kiss a cow's cunt!", "Go drown in a lake of diet coke you neutered asshole.",
                                              "If a zombie was looking for brains, he'd walk right by you.", 
                                              "Are you always this stupid, or is this a special occasion?", 
                                              "You have a face for radio, moron.", "Are you always this stupid or is today a special occasion?",
                                              "If ugly were a crime, you'd get a life sentence.", "You're so fat, you could sell shade."})

    emote2txt["surrender"] = BanditUtils.Choice({"Forgive me!", "Sorry everyone!", "My apologies", "I beg your pardon!", "My bad!"})

    emote2txt["stop"] = BanditUtils.Choice({"Can you stop?", "Stop please!", "Can you wait?"})

    emote2txt["followme"] = BanditUtils.Choice({"Come with me!", "Follow my lead!", "Follow me!", "Accompany me",
                                                "Stick with me", "Team up with me!", "Come along", "Walk with me",
                                                "Tag along", "Be with me", "Follow my path", "Accompany my journey!", "Sitck by me",
                                                "Team up together!", "Walk beside me", "Stay with me", "Be my companion",
                                                "Let's go!"})

    if emote2txt[emote] then
        BWOChat.Say(emote2txt[emote])
    end
end


LuaEventManager.AddEvent("OnEmote")

Events.OnKeyPressed.Add(onKeyPressed)
Events.OnEmote.Add(onEmote)

