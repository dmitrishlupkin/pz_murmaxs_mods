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
table.insert(data, {query={"g", "day"}, res="G’day! Hope it’s a good one."})
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
table.insert(data, {query={"yummy", "food"}, res="Glad you think so!"})
table.insert(data, {query={"mouth", "watering"}, res="Thank you, it sure is!"})
table.insert(data, {query={"scrumptious", "dish"}, res="You're too kind!"})
table.insert(data, {query={"delectable", "meal"}, res="Appreciate the compliment!"})
table.insert(data, {query={"savory", "flavor"}, res="Glad you like it!"})
table.insert(data, {query={"tempting", "plate"}, res="Thanks, it's a favorite!"})
table.insert(data, {query={"spicy", "kick"}, res="Enjoy the heat!"})
table.insert(data, {query={"sweet", "treat"}, res="Happy to hear that!"})
table.insert(data, {query={"perfect", "bite"}, res="Much appreciated!"})
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
table.insert(data, {query={"heavenly", "meal"}, res="Your praise is much appreciated!"})
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
table.insert(data, {query={"sex"}, res="I'm not interested'.", anim="No"})
table.insert(data, {query={"take", "bed"}, res="I'm not interested.", anim="No"})
table.insert(data, {query={"go", "bed"}, res="I'm not interested.", anim="No"})
table.insert(data, {query={"want", "hang", "out"}, res="I'm not interested.", anim="No"})
table.insert(data, {query={"wanna", "hang", "out"}, res="I'm not interested.", anim="No"})
table.insert(data, {query={"go", "bed"}, res="I'm not interested.", anim="No"})
table.insert(data, {query={"sleep", "me"}, res="I'm not interested!.", anim="No"})
table.insert(data, {query={"dinner", "me"}, res="Sure! Let's go!", anim="Yes", action="JOIN"})
table.insert(data, {query={"lunch", "me"}, res="Sure! Let's go!", anim="Yes", action="JOIN"})
table.insert(data, {query={"take", "drink"}, res="Sure! Let's go!", anim="Clap", action="JOIN"})
table.insert(data, {query={"have", "a", "drink"}, res="Sure! Let's go!", anim="Clap", action="JOIN"})
table.insert(data, {query={"buy", "drink"}, res="Sure! Let's go!", anim="Clap", action="JOIN"})
table.insert(data, {query={"take", "coffee"}, res="Sure! Let's go!", anim="Yes", action="JOIN"})
table.insert(data, {query={"buy", "coffee"}, res="Sure! Let's go!", anim="Yes", action="JOIN"})
table.insert(data, {query={"i", "love", "you"}, res="I'm sure you do!", anim="Yes"})
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
table.insert(data, {query={"are", "you", "infected"}, res="No, are you?"})
table.insert(data, {query={"are", "you", "hungry"}, res="Funny. I ate recently, but I am hungry again."})
table.insert(data, {query={"are", "you", "thirsty"}, res="Not that much."})
table.insert(data, {query={"are", "you", "angry"}, res="%MOOD"})
table.insert(data, {query={"how", "old", "are", "you"}, res="Oh I have just respawned recently!"})
table.insert(data, {query={"where", "you", "from"}, res="I'm from %CITY."})
table.insert(data, {query={"where", "am", "i"}, res="You're in %CITY."})
table.insert(data, {query={"where", "are", "we"}, res="We're in %CITY."})
table.insert(data, {query={"do", "you", "like"}, res="Yeah, sure."})
table.insert(data, {query={"do", "you", "love"}, res="Yeah, sure."})
table.insert(data, {query={"what", "are", "you", "doing"}, res="Living the day!"})
table.insert(data, {query={"how", "life"}, res="Life's a rollercoaster, but I'm hanging on."})
table.insert(data, {query={"what", "your", "story"}, res="Just trying to survive in this world."})
table.insert(data, {query={"how", "was", "your", "day"}, res="It's been a tough one, but I'm still here."})
table.insert(data, {query={"do", "you", "miss", "anyone"}, res="Yeah, I miss a lot of people."})
table.insert(data, {query={"what", "your", "plan"}, res="Plan? Just take it one day at a time."})
table.insert(data, {query={"how", "your", "family"}, res="They're holding up, just like me."})
table.insert(data, {query={"do", "you", "have", "friends"}, res="Got a few. It's tough to keep them these days."})
table.insert(data, {query={"do", "you", "need", "help"}, res="I think we're all in need of a little help."})
table.insert(data, {query={"what", "your", "goal"}, res="To survive and maybe find some peace."})
table.insert(data, {query={"what", "your", "favorite", "memory"}, res="I cherish the good old days."})
table.insert(data, {query={"what", "your", "biggest", "fear"}, res="Losing hope."})
table.insert(data, {query={"do", "you", "have", "a", "dream"}, res="I dream of a safer world."})
table.insert(data, {query={"what", "your", "favorite", "place"}, res="Somewhere quiet and safe."})
table.insert(data, {query={"how", "do", "you", "stay", "positive"}, res="I focus on the little things."})
table.insert(data, {query={"what", "do", "you", "enjoy", "most"}, res="I enjoy a moment of peace."})
table.insert(data, {query={"do", "you", "have", "any", "regrets"}, res="Yeah, I've got a few."})
table.insert(data, {query={"what", "your", "motivation"}, res="Staying alive and helping others."})
table.insert(data, {query={"what", "your", "biggest", "challenge"}, res="Finding hope in dark times."})
table.insert(data, {query={"how", "do", "you", "relax"}, res="I find solace in the little things."})
table.insert(data, {query={"what", "your", "best", "advice"}, res="Keep going, no matter what."})
table.insert(data, {query={"hobby", "you"}, res="I like collecting dead bodies in my basement."})
table.insert(data, {query={"hobby", "your"}, res="I like collecting dead bodies in my basement. "})

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

table.insert(data, {query={"believe", "god"}, res="Jesus is my savior!"})
table.insert(data, {query={"believe", "love"}, res="I do believe in love!"})
table.insert(data, {query={"believe", "aliens"}, res="Aliens? Hell no!"})
table.insert(data, {query={"believe", "zombies"}, res="Zombies? Hell no!"})
table.insert(data, {query={"believe", "magic"}, res="No, I don't believe in magic!"})
table.insert(data, {query={"believe", "ghosts"}, res="Ghosts? I don't think so!"})
table.insert(data, {query={"believe", "supernatural"}, res="Supernatural? Not really!"})
table.insert(data, {query={"believe", "fate"}, res="I think we make our own fate!"})
table.insert(data, {query={"believe", "karma"}, res="What goes around, comes around!"})
table.insert(data, {query={"believe", "reincarnation"}, res="Reincarnation? Not my cup of tea!"})
table.insert(data, {query={"believe", "destiny"}, res="I believe we shape our own destiny!"})
table.insert(data, {query={"believe", "miracles"}, res="Miracles? Maybe, who knows!"})
table.insert(data, {query={"believe", "soulmates"}, res="Soulmates? It's a nice thought!"})
table.insert(data, {query={"believe", "luck"}, res="Luck? Sometimes we make our own luck!"})
table.insert(data, {query={"believe", "afterlife"}, res="Afterlife? I haven't thought about it much!"})
table.insert(data, {query={"believe", "heaven"}, res="Heaven? It's a comforting idea!"})
table.insert(data, {query={"believe", "hell"}, res="Hell? I try to stay away from dark thoughts!"})
table.insert(data, {query={"believe", "angels"}, res="Angels? It's a nice idea!"})
table.insert(data, {query={"believe", "demons"}, res="Demons? I prefer to stay positive!"})
table.insert(data, {query={"believe", "fairies"}, res="Fairies? Not really my thing!"})
table.insert(data, {query={"believe", "psychics"}, res="Psychics? I'm skeptical!"})
table.insert(data, {query={"believe", "astrology"}, res="Astrology? It's fun, but not for me!"})
table.insert(data, {query={"believe", "tarot"}, res="Tarot? Interesting, but I'm not convinced!"})
table.insert(data, {query={"believe", "Bigfoot"}, res="Bigfoot? Not buying it!"})
table.insert(data, {query={"believe", "Loch Ness Monster"}, res="Loch Ness Monster? Sounds like a fairy tale!"})

table.insert(data, {query={"you", "speak"}, res="I do speak English only."})
table.insert(data, {query={"what", "speak", "language"}, res="I speak only English."})
table.insert(data, {query={"have", "boyfriend"}, res="That's not your business!", anim="No"})
table.insert(data, {query={"have", "girlfriend"}, res="That's not your business!", anim="No"})
table.insert(data, {query={"have", "wife"}, res="That's not your business!", anim="No"})
table.insert(data, {query={"have", "husband"}, res="That's not your business!", anim="No"})
table.insert(data, {query={"you", "homo"}, res="That's not your business!", anim="No"})
table.insert(data, {query={"you", "gay"}, res="That's not your business!", anim="No"})
table.insert(data, {query={"you", "lesbian"}, res="That's not your business!", anim="No"})
table.insert(data, {query={"have", "time"}, res="Sorry, I'm in a hurry!", anim="No"})
table.insert(data, {query={"what", "you", "doing"}, res="I'm doing what I was programmed to."})
table.insert(data, {query={"are", "you", "single"}, res="That's personal, isn't it?", anim="No"})
table.insert(data, {query={"are", "you", "married"}, res="That's personal, isn't it?", anim="No"})
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
table.insert(data, {query={"like", "your"}, res="Thank you! You are very kind.", anim="Clap"})
table.insert(data, {query={"like", "my"}, res="Yes, I think I like it.", anim="Yes"})
table.insert(data, {query={"you", "computer"}, res="No shit."})
table.insert(data, {query={"you", "ugly"}, res="So are you!"})
table.insert(data, {query={"you", "dumb"}, res="You are not so bright yourself!"})
table.insert(data, {query={"you", "stupid"}, res="You are not so bright yourself!"})
table.insert(data, {query={"you", "pretty"}, res="Thank you!"})
table.insert(data, {query={"you", "beautiful"}, res="Thank you!"})
table.insert(data, {query={"you", "bleeding"}, res="UGHH!"})
table.insert(data, {query={"you", "die"}, res="I hope you are wrong."})
table.insert(data, {query={"you", "friend"}, res="I don't know you that well"})
table.insert(data, {query={"we", "die"}, res="I hope you are wrong."})
table.insert(data, {query={"you", "die"}, res="I hope you are wrong."})
table.insert(data, {query={"what", "in", "briefcase"}, res="Nothing you should know about!"})
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
table.insert(data, {query={"what", "year", "is", "it"}, res="It's 1993. That's a strange question!"})
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
table.insert(data, {query={"saw", "dead"}, res="That's really terrible!"})

table.insert(data, {query={"streets", "blocked"}, res="Yeah, it looks that way."})
table.insert(data, {query={"street", "blocked"}, res="Yes, it appears so."})
table.insert(data, {query={"road", "blocked"}, res="Yes, it appears so."})

table.insert(data, {query={"what", "happened"}, res="Can't you tell? Everyone's losing their minds!"})
table.insert(data, {query={"what", "going", "on"}, res="Can't you see? People are going nuts!"})
table.insert(data, {query={"what", "the", "hell"}, res="Isn't it obvious? Everyone's gone crazy!"})

table.insert(data, {query={"why", "car", "wreck"}, res="There must have been an accident before!"})
table.insert(data, {query={"why", "corpse"}, res="There must have been some accident!"})
table.insert(data, {query={"why", "fire"}, res="Must have been some accident!"})
table.insert(data, {query={"why", "people", "in", "my"}, res="Don't you like unexpected guests?"})
table.insert(data, {query={"why", "you", "in", "my"}, res="Don't you like unexpected guests?"})
table.insert(data, {query={"why", "street"}, res="Can't you see that pavements are missing in so many places in the town?"})
table.insert(data, {query={"why", "shrugging"}, res="I don't know what to do next."})
table.insert(data, {query={"why", "shrug"}, res="I don't know what to do next."})
table.insert(data, {query={"why", "call", "police"}, res="Because I saw everything."})

-- in-game advice
table.insert(data, {query={"how", "save", "money"}, res="Try to avoid unnecessary expenses and save what you can."})
table.insert(data, {query={"how", "make", "money"}, res="There are lots of ways to make money, just keep working at it."})
table.insert(data, {query={"how", "earn", "cash"}, res="You can earn cash by completing jobs or scavenging."})
table.insert(data, {query={"how", "collect", "money"}, res="Collect money through various activities and tasks."})
table.insert(data, {query={"how", "deposit", "money"}, res="In a bank, but i think they are not open anymore for some reason."})
table.insert(data, {query={"how", "withdraw", "money"}, res="The ATMs are not working anymore."})
table.insert(data, {query={"how", "use", "ATM"}, res="JI've heard that ATMs are not working."})
table.insert(data, {query={"how", "invest"}, res="Look for safe investment opportunities."})
table.insert(data, {query={"how", "prepare", "apocalypse"}, res="You collect necessary items, hide in a safe place and pray!"})
table.insert(data, {query={"how", "prepare", "ourbreak"}, res="You collect necessary items, hide in a safe place and pray!"})
table.insert(data, {query={"how", "survive"}, res="You collect necessary items, hide in a safe place and pray!"})
table.insert(data, {query={"how", "nuclear", "fallout"}, res="Wear a hazmat suit to avoid radiation hazard."})
table.insert(data, {query={"how", "nuke", "fallout"}, res="Wear a hazmat suit to avoid radiation hazard."})
table.insert(data, {query={"how", "nuclear", "radiation"}, res="Wear a hazmat suit to avoid radiation hazard."})
table.insert(data, {query={"how", "nuke", "radiation"}, res="Wear a hazmat suit to avoid radiation hazard."})
table.insert(data, {query={"how", "nuclear", "strike"}, res="You'd better hide in a basement or get far from the city."})
table.insert(data, {query={"how", "nuclear", "bomb"}, res="You'd better hide in a basement or get far from the city."})
table.insert(data, {query={"how", "nuke", "strike"}, res="You'd better hide in a basement or get far from the city."})
table.insert(data, {query={"how", "nuke", "bomb"}, res="You'd better hide in a basement or get far from the city."})
table.insert(data, {query={"how", "get", "car"}, res="I don't think you can buy or rent one anywhere around."})
table.insert(data, {query={"how", "buy", "car"}, res="I don't think you can buy or rent one anywhere around."})
table.insert(data, {query={"how", "buy", "house"}, res="I don't think you can buy a house."})
table.insert(data, {query={"how", "earn"}, res="Perform your job, or pick up trash from the street and such. "})
table.insert(data, {query={"how", "buy"}, res="Just take items from the shop and payment will be automatic, its some new bluetooth bullshit or something. "})
table.insert(data, {query={"i", "to", "buy"}, res="Just take items from the shop and payment will be automatic, its some new bluetooth bullshit or something. "})
table.insert(data, {query={"how", "pay"}, res="Just take items from the shelves and payment will be automatic. "})
table.insert(data, {query={"i", "to", "pay"}, res="Just take items from the shelves and payment will be automatic. "})
table.insert(data, {query={"is", "money", "safe"}, res="Keep it secure and it should be safe."})
table.insert(data, {query={"where", "i", "keep", "money"}, res="You can keep it in a bank or a safe place."})
table.insert(data, {query={"where", "i", "spend", "money"}, res="Spend your money in the shops."})
table.insert(data, {query={"where", "i", "find", "job"}, res="You make money by performing your job duty. If you don't know how, start picking up the trash."})
table.insert(data, {query={"where", "i", "get", "paid"}, res="You get paid by performing your job duty. If you don't know how, start picking up the trash."})

-- Giving orders
table.insert(data, {query={"can", "stop"}, res="Can't stop now, I'm on a mission!", anim="No"})
table.insert(data, {query={"stop", "please"}, res="I'm really in a rush, can't stop!", anim="No"})
table.insert(data, {query={"can", "wait"}, res="I'm in a hurry, can't wait!", anim="No"})
table.insert(data, {query={"wait", "me"}, res="I'm in a rush, can't wait around!", anim="No"})
table.insert(data, {query={"help", "me"}, res="You're on your own.", anim="Shrug"})
table.insert(data, {query={"help", "you"}, res="You are very kind, but I don't need help at the moment.", anim="No"})
table.insert(data, {query={"give", "me"}, res="Sorry, I can't give you that.", anim="Shrug"})
table.insert(data, {query={"can", "i", "have"}, res="Sorry, I can't give you that.", anim="Shrug"})
table.insert(data, {query={"give", "you"}, res="Thanks, but I don't need that.", anim="No"})
table.insert(data, {query={"i", "need"}, res="Sorry, I can't help you with that.", anim="No"})
table.insert(data, {query={"do", "you", "need"}, res="Thanks, but I don't need that.", anim="No"})
table.insert(data, {query={"open", "door"}, res="We are apparently closed!", anim="No"})
table.insert(data, {query={"open", "window"}, res="I'm not opening it.", anim="No"})
table.insert(data, {query={"close", "window"}, res="No, it's stuffy in here.", anim="No"})
table.insert(data, {query={"sit", "down"}, res="I prefer not to.", anim="No", all=true})
table.insert(data, {query={"run", "away"}, res="Why would you want me to run away?", anim="No", all=true})
table.insert(data, {query={"do", "you", "have"}, res="Sorry, I don't.", anim="No"})
table.insert(data, {query={"have", "you", "got"}, res="Sorry, I don't.", anim="No"})
table.insert(data, {query={"a", "you", "got"}, res="Sorry, I don't.", anim="No"})
table.insert(data, {query={"did", "you", "have"}, res="Unfortunately, no.", anim="No"})
table.insert(data, {query={"had", "you", "got"}, res="I'm afraid not.", anim="No"})
table.insert(data, {query={"can", "you", "spare"}, res="Sorry, I can't.", anim="No"})
table.insert(data, {query={"is", "there", "any"}, res="No, there's none.", anim="No"})
table.insert(data, {query={"do", "you", "possess"}, res="Sadly, I don't.", anim="No"})
table.insert(data, {query={"do", "you", "own"}, res="No, I don't own that.", anim="No"})
table.insert(data, {query={"can", "I", "borrow"}, res="Sorry, I don't have it.", anim="No"})
table.insert(data, {query={"is", "there", "available"}, res="No, nothing available.", anim="No"})
table.insert(data, {query={"do", "you", "stock"}, res="Not in stock, sorry.", anim="No"})
table.insert(data, {query={"shut", "up"}, res="No, I won't.", anim="No"})
table.insert(data, {query={"be", "quiet"}, res="I won't be quiet.", anim="No"})
table.insert(data, {query={"stop", "talking"}, res="I'm not going to stop.", anim="No"})
table.insert(data, {query={"silence"}, res="I refuse.", anim="No"})
table.insert(data, {query={"quiet", "down"}, res="No, I will keep talking.", anim="No"})
table.insert(data, {query={"zip", "it"}, res="I'm not zipping it.", anim="No"})
table.insert(data, {query={"hush"}, res="Not going to happen.", anim="No"})
table.insert(data, {query={"shush"}, res="I won't shush.", anim="No"})
table.insert(data, {query={"keep", "it", "down"}, res="No, I won't keep it down.", anim="No"})
table.insert(data, {query={"stop", "speaking"}, res="I refuse to stop.", anim="No"})
table.insert(data, {query={"stop", "smoking"}, res="I refuse to stop.", anim="Smoke"})
table.insert(data, {query={"drop", "your"}, res="I'm not dropping anything!", anim="No"})
table.insert(data, {query={"drop", "it"}, res="I'm not dropping anything!", anim="No"})
table.insert(data, {query={"drop", "that"}, res="I'm not dropping anything!", anim="No"})

table.insert(data, {query={"leave", "you"}, res="I'm staying where I want to!"})
table.insert(data, {query={"get", "lost"}, res="I'm staying where I want to!"})
table.insert(data, {query={"get", "out"}, res="I'm staying where I want to!"})
table.insert(data, {query={"leave", "your"}, res="I'm keeping it with me!"})
table.insert(data, {query={"borrow", "i"}, res="No!", anim="No"})
table.insert(data, {query={"lend", "me"}, res="No!", anim="No"})
table.insert(data, {query={"spare", "change"}, res="You need to earn money yourself. God damn bums in this city im sick of this shit. Where's my tax money going. "})
table.insert(data, {query={"where", "i", "get", "money"}, res="You can earn money by doing various tasks around the city."})
table.insert(data, {query={"need", "cash"}, res="Go out and find a job or hustle to earn it."})
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
table.insert(data, {query={"come", "here"}, res="Alright, I'm coming.", anim="Yes", action="JOIN"})
table.insert(data, {query={"join", "my", "group"}, res="I'm in, let's go.", anim="Yes", action="JOIN"})
table.insert(data, {query={"follow", "my", "lead"}, res="Got it, I'll follow.", anim="Yes", action="JOIN"})
table.insert(data, {query={"follow", "me"}, res="Got it, I'll follow.", anim="Yes", action="JOIN"})
table.insert(data, {query={"accompany", "me"}, res="Sure thing.", anim="Yes", action="JOIN"})
table.insert(data, {query={"stick", "with", "me"}, res="Okay, I'm sticking with you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"team", "up", "with", "me"}, res="Let's team up.", anim="Yes", action="JOIN"})
table.insert(data, {query={"come", "along"}, res="Alright, coming along.", anim="Yes", action="JOIN"})
table.insert(data, {query={"walk", "with", "me"}, res="Okay, let's walk together.", anim="Yes", action="JOIN"})
table.insert(data, {query={"tag", "along"}, res="Sure, I'll tag along.", anim="Yes", action="JOIN"})
table.insert(data, {query={"be", "with", "me"}, res="I'm with you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"come", "with", "me"}, res="Let's move together.", anim="Yes", action="JOIN"})
table.insert(data, {query={"join", "my", "team"}, res="I'm in, let's roll.", anim="Yes", action="JOIN"})
table.insert(data, {query={"follow", "my", "path"}, res="I'm right behind you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"accompany", "my", "journey"}, res="Sure, I'll come along.", anim="Yes", action="JOIN"})
table.insert(data, {query={"stick", "by", "me"}, res="Got it, sticking with you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"team", "up", "together"}, res="Let's make a great team.", anim="Yes", action="JOIN"})
table.insert(data, {query={"come", "along", "with", "me"}, res="Alright, let's go together.", anim="Yes", action="JOIN"})
table.insert(data, {query={"walk", "beside", "me"}, res="Okay, walking with you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"tag", "along", "with", "me"}, res="Sure, I'll join in.", anim="Yes", action="JOIN"})
table.insert(data, {query={"stay", "with", "me"}, res="I'm staying with you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"be", "my", "companion"}, res="I'd be happy to join you.", anim="Yes", action="JOIN"})
table.insert(data, {query={"lets", "go"}, res="Ok, let's do it!", anim="Yes", action="JOIN"})
table.insert(data, {query={"let's", "go"}, res="Ok, let's do it!", anim="Yes", action="JOIN"})

table.insert(data, {query={"stop", "following", "me"}, res="I thought you need me, but fine!", action="GUARD"})
table.insert(data, {query={"dont", "follow", "me"}, res="I thought you need me, but fine!", action="GUARD"})
table.insert(data, {query={"don't", "follow", "me"}, res="I thought you need me, but fine!", action="GUARD"})
table.insert(data, {query={"stay", "here"}, res="I thought you need me, but fine!", action="GUARD"})
table.insert(data, {query={"stay", "put"}, res="I thought you need me, but fine!", action="GUARD"})
table.insert(data, {query={"wait", "here"}, res="Boring, but fine!", action="GUARD"})
table.insert(data, {query={"guard", "the"}, res="Ok, I'll guard here!", action="GUARD"})
table.insert(data, {query={"guard", "this"}, res="Ok, I'll guard here!", action="GUARD"})
table.insert(data, {query={"guard", "that"}, res="Ok, I'll guard here!", action="GUARD"})
table.insert(data, {query={"stop", "here"}, res="Ok, not moving!", action="GUARD"})

table.insert(data, {query={"go", "home"}, res="Ok, I'm going home!", action="BASE"})
table.insert(data, {query={"return", "home"}, res="Fine! Heading back home!", action="BASE"})
table.insert(data, {query={"head", "home"}, res="Ok, returning to our house now!", action="BASE"})

table.insert(data, {query={"leave", "me"}, res="I thought you need me, but fine!", action="LEAVE"})
table.insert(data, {query={"go", "away"}, res="I thought you need me, but fine!", action="LEAVE"})

table.insert(data, {query={"dance"}, res="Sure!", anim="DanceRaiseTheRoof", all=true})
table.insert(data, {query={"show", "me", "your", "moves"}, res="Here we go!", anim="DanceRaiseTheRoof", all=true})
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

table.insert(data, {query={"hands", "up"}, res="Ok!", anim="Surrender", all=true})
table.insert(data, {query={"robbery"}, res="Ok!", anim="Surrender", all=true})
table.insert(data, {query={"hands", "up"}, res="Alright, hands are up!", anim="Surrender", all=true})
table.insert(data, {query={"this", "is", "a", "stickup"}, res="Got it, hands in the air!", anim="Surrender", all=true})
table.insert(data, {query={"give", "me", "everything"}, res="Okay, take it easy!", anim="Surrender", all=true})
table.insert(data, {query={"hold", "up"}, res="Alright, no need to get violent!", anim="Surrender", all=true})
table.insert(data, {query={"you", "are", "robbed"}, res="Okay, hands are up!", anim="Surrender", all=true})
table.insert(data, {query={"don't", "move"}, res="Okay, I'm not moving!", anim="Surrender", all=true})
table.insert(data, {query={"freeze"}, res="Alright, staying put!", anim="Surrender", all=true})
table.insert(data, {query={"stickup"}, res="Got it, hands in the air!", anim="Surrender", all=true})
table.insert(data, {query={"don't", "try", "anything"}, res="Alright, no sudden movements!", anim="Surrender", all=true})

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
table.insert(data, {query={"fucking"}, res="Cursing is the devil's speech."})
table.insert(data, {query={"ass"}, res="Cursing is the devil's speech."})
table.insert(data, {query={"i", "will", "shoot"}, res="Fuck off!", action="HOSTILE"})
table.insert(data, {query={"i", "will", "kill"}, res="Fuck off!", action="HOSTILE"})
table.insert(data, {query={"i", "will", "hit"}, res="Fuck off!", action="HOSTILE"})
table.insert(data, {query={"i", "will", "use", "force"}, res="Fuck off!", action="HOSTILE"})
table.insert(data, {query={"i", "will", "attack"}, res="Fuck off!", action="HOSTILE"})
table.insert(data, {query={"i", "will", "beat"}, res="Fuck off!", action="HOSTILE"})
table.insert(data, {query={"suck"}, res="Fuck off!", action="HOSTILE"})
table.insert(data, {query={"fag"}, res="Fuck off!", action="HOSTILE"})
table.insert(data, {query={"fuck"}, res="Fuck you!", action="HOSTILE"})
table.insert(data, {query={"fucker"}, res="Fuck you!", action="HOSTILE"})
table.insert(data, {query={"dick"}, res="You're a pussy ass bitch!!", action="HOSTILE"})
table.insert(data, {query={"pussy"}, res="The fuck did you say to me little bitch?!", action="HOSTILE"})
table.insert(data, {query={"undress"}, res="Leave me the fuck alone pervert!", action="HOSTILE"})
table.insert(data, {query={"bitch"}, res="Fuck you!", action="HOSTILE"})
table.insert(data, {query={"asshole"}, res="Fuck you!", action="HOSTILE"})
table.insert(data, {query={"xhornx"}, res="Stop beeping!", action="HOSTILE"}) -- special command when player uses horn
table.insert(data, {query={"mod", "jank"}, res="Fuck you!", action="HOSTILE"})
table.insert(data, {query={"mod", "janky"}, res="Fuck you!", action="HOSTILE"})
table.insert(data, {query={"game", "jank"}, res="Fuck you!", action="HOSTILE"})
table.insert(data, {query={"game", "janky"}, res="Fuck you!", action="HOSTILE"})

-- Advice
table.insert(data, {query={"how", "stay", "healthy"}, res="Eat well and stay active."})
table.insert(data, {query={"how", "make", "friends"}, res="Be friendly and talk to people."})
table.insert(data, {query={"how", "be", "productive"}, res="Set goals and focus on them."})
table.insert(data, {query={"how", "save", "money"}, res="Spend less and save more."})
table.insert(data, {query={"how", "reduce", "stress"}, res="Take breaks and relax."})
table.insert(data, {query={"how", "learn", "new", "skills"}, res="Practice and don't give up."})
table.insert(data, {query={"how", "manage", "time"}, res="Plan your day and stick to it."})
table.insert(data, {query={"how", "improve", "communication"}, res="Listen and be clear."})
table.insert(data, {query={"how", "boost", "confidence"}, res="Believe in yourself."})
table.insert(data, {query={"how", "handle", "conflict"}, res="Stay calm and talk it out."})

-- Culture
table.insert(data, {query={"what", "your", "culture"}, res="I come from a blend of different backgrounds, so it's a mix!"})
table.insert(data, {query={"what", "traditional", "food"}, res="In my culture, we love to cook hearty stews and fresh bread."})
table.insert(data, {query={"what", "customs", "you", "follow"}, res="We have a lot of family gatherings and celebrate with music and dance."})
table.insert(data, {query={"what", "are", "your", "holidays"}, res="We celebrate a lot of holidays with big feasts and community events."})
table.insert(data, {query={"how", "you", "celebrate", "new", "year"}, res="New Year's is all about fireworks and big parties!"})
table.insert(data, {query={"what", "your", "national", "dress"}, res="We wear colorful traditional outfits, usually with intricate embroidery."})
table.insert(data, {query={"you", "have", "festivals"}, res="Yes, we have lots of festivals with music, dancing, and food stalls."})
table.insert(data, {query={"how", "you", "celebrate", "weddings"}, res="Weddings are huge in our culture, with lots of ceremonies and celebrations."})
table.insert(data, {query={"you", "have", "any", "traditions"}, res="We have a tradition of storytelling and passing down myths and legends."})
table.insert(data, {query={"how", "you", "celebrate", "birthdays"}, res="Birthdays are celebrated with cake, presents, and gathering with loved ones."})
table.insert(data, {query={"what", "games", "you", "play"}, res="We love playing traditional games that have been passed down for generations."})
table.insert(data, {query={"how", "you", "celebrate", "harvest"}, res="Harvest season is celebrated with a big community feast and lots of dancing."})
table.insert(data, {query={"what", "traditional", "music"}, res="Our traditional music is usually upbeat and involves lots of drums and flutes."})
table.insert(data, {query={"you", "have", "family", "rituals"}, res="Yes, we have rituals like family dinners every Sunday and holiday traditions."})
table.insert(data, {query={"how", "you", "celebrate", "births"}, res="Births are celebrated with naming ceremonies and lots of food and gifts."})
table.insert(data, {query={"what", "your", "traditional", "art"}, res="Our traditional art includes pottery, weaving, and painting."})
table.insert(data, {query={"you", "have", "any", "special", "dances"}, res="We have traditional dances that are performed during festivals and celebrations."})
table.insert(data, {query={"how", "you", "celebrate", "anniversaries"}, res="Anniversaries are celebrated with special dinners and sometimes even parties."})
table.insert(data, {query={"what", "your", "traditional", "architecture"}, res="Our traditional architecture features a lot of wood and intricate carvings."})
table.insert(data, {query={"how", "you", "celebrate", "death"}, res="We have ceremonies to honor the deceased and celebrate their life."})

-- Politics
table.insert(data, {query={"who", "president"}, res="Bill Clinton."})
table.insert(data, {query={"republican"}, res="I don't vote for any of these bastards!"})
table.insert(data, {query={"democratic"}, res="I don't vote for any of these bastards!"})
table.insert(data, {query={"libertarian"}, res="I don't vote for any of these bastards!"})
table.insert(data, {query={"communism"}, res="Communism makes everyone equal.. in their poverty."})
table.insert(data, {query={"capitalism"}, res="Under capitalism, man exploits man. Under commiunism, it's just the opposite."})
table.insert(data, {query={"socialism"}, res="Socialism is great for solving problems unknown in other economic systems."})

-- Sports
table.insert(data, {query={"what", "sports", "you"}, res="I enjoy playing soccer and basketball."})
table.insert(data, {query={"how", "you", "fit"}, res="I try to work out regularly and eat healthy."})
table.insert(data, {query={"what", "your", "exercise"}, res="I usually do a mix of cardio and strength training."})
table.insert(data, {query={"how", "often", "you", "exercise"}, res="I aim for at least three times a week."})
table.insert(data, {query={"you", "go", "gym"}, res="Yes, I go to the gym a few times a week."})
table.insert(data, {query={"what", "your", "favorite", "sport"}, res="I love playing soccer the most."})
table.insert(data, {query={"you", "play", "sports"}, res="Yes, I play soccer and sometimes basketball."})
table.insert(data, {query={"how", "you", "motivated"}, res="I set goals for myself and track my progress."})
table.insert(data, {query={"what", "best", "exercise"}, res="It really depends on your goals, but I like running."})
table.insert(data, {query={"you", "fitness", "tips"}, res="Stay consistent and find activities you enjoy."})
table.insert(data, {query={"what", "your", "diet"}, res="I try to eat a balanced diet with plenty of fruits and veggies."})
table.insert(data, {query={"you", "have", "trainer"}, res="No, I follow my own workout plans."})
table.insert(data, {query={"how", "prevent", "injuries"}, res="I warm up before workouts and make sure to stretch."})
table.insert(data, {query={"what", "sports", "you", "like", "watch"}, res="I love watching soccer and basketball games."})
table.insert(data, {query={"you", "yoga"}, res="Yes, I find yoga great for flexibility and relaxation."})
table.insert(data, {query={"what", "your", "workout"}, res="I really enjoy high-intensity interval training (HIIT)."})
table.insert(data, {query={"do", "you", "run"}, res="Yes, I like to go for runs in the park."})
table.insert(data, {query={"how", "you", "hydrated"}, res="I make sure to drink plenty of water throughout the day."})
table.insert(data, {query={"you", "play", "team", "sports"}, res="Yes, I play on a local soccer team."})
table.insert(data, {query={"what", "your", "fitness", "goal"}, res="My goal is to stay healthy and maintain my fitness."})

-- Home and Living
table.insert(data, {query={"how", "fix", "leaky", "faucet"}, res="Try tightening the connections or replacing the washer."})
table.insert(data, {query={"how", "decorate", "space"}, res="Use multi-functional furniture and keep it clutter-free."})
table.insert(data, {query={"how", "paint", "room"}, res="Start with a primer and use even strokes with a roller."})
table.insert(data, {query={"how", "save", "energy"}, res="Turn off lights when not in use and use energy-efficient appliances."})
table.insert(data, {query={"how", "clean", "carpet"}, res="Vacuum regularly and use a carpet cleaner for deep cleaning."})
table.insert(data, {query={"how", "organize", "closet"}, res="Sort items by category and use storage bins and shelves."})
table.insert(data, {query={"how", "hang", "pictures"}, res="Use a level and picture hooks for accurate placement."})
table.insert(data, {query={"how", "remove", "stains"}, res="Blot the stain and use a stain remover or a mix of water and vinegar."})
table.insert(data, {query={"how", "make", "home", "cozy"}, res="Add soft textiles, warm lighting, and personal touches."})
table.insert(data, {query={"how", "arrange", "furniture"}, res="Create a focal point and leave enough space for movement."})
table.insert(data, {query={"how", "repair", "wall"}, res="Patch holes with spackle and sand it smooth before painting."})
table.insert(data, {query={"how", "clean", "windows"}, res="Use a mixture of water and vinegar and wipe with a microfiber cloth."})
table.insert(data, {query={"how", "maintain", "garden"}, res="Water regularly, remove weeds, and prune plants."})
table.insert(data, {query={"how", "choose", "paint", "color"}, res="Consider the room's lighting and the mood you want to create."})
table.insert(data, {query={"how", "keep", "house", "cool"}, res="Use fans, close blinds during the day, and open windows at night."})
table.insert(data, {query={"how", "declutter"}, res="Go room by room, and keep only what you need and love."})
table.insert(data, {query={"how", "set", "table"}, res="Place plates in the center, forks on the left, knives and spoons on the right."})
table.insert(data, {query={"how", "clean", "kitchen"}, res="Wipe down surfaces, clean appliances, and sweep the floor."})
table.insert(data, {query={"how", "create", "storage"}, res="Use shelves, hooks, and storage bins to maximize space."})
table.insert(data, {query={"how", "freshen", "air"}, res="Open windows, use air purifiers, and place plants around the house."})

-- Fashion 
table.insert(data, {query={"what", "should", "I", "wear"}, res="Wear something that makes you feel confident and comfortable."})
table.insert(data, {query={"how", "do", "I", "look"}, res="You look great! Rock that outfit."})
table.insert(data, {query={"what", "trending"}, res="Right now, it's all about sustainable and eco-friendly fashion."})
table.insert(data, {query={"how", "to", "style", "this"}, res="Try pairing it with some statement accessories."})
table.insert(data, {query={"what", "your", "favorite", "brand"}, res="I love brands that focus on sustainability and ethical practices."})
table.insert(data, {query={"what", "colors", "look", "good", "on", "me"}, res="It depends on your skin tone, but you can't go wrong with classic neutrals."})
table.insert(data, {query={"you", "like", "my", "outfit"}, res="Absolutely! It's stylish and suits you well."})
table.insert(data, {query={"how", "to", "accessorize"}, res="Less is more. Choose a few key pieces that complement your outfit."})
table.insert(data, {query={"what", "style"}, res="Vintage and retro looks are making a comeback."})
table.insert(data, {query={"how", "to", "dress", "for", "party"}, res="Go for something fun and comfortable so you can dance the night away."})
table.insert(data, {query={"what", "your", "outfit"}, res="I love a good pair of jeans and a comfy sweater."})
table.insert(data, {query={"what", "shoes", "to", "wear"}, res="Pick shoes that match your outfit and are comfortable enough for the day."})
table.insert(data, {query={"how", "to", "layer", "clothing"}, res="Start with a base layer, add a mid-layer, and finish with a stylish outer layer."})
table.insert(data, {query={"you", "follow", "fashion", "trends"}, res="I like to stay updated but I prefer timeless and classic pieces."})
table.insert(data, {query={"what", "your", "style"}, res="My style is all about comfort and versatility with a touch of elegance."})
table.insert(data, {query={"how", "to", "dress", "casual"}, res="Go for jeans, a simple tee, and comfortable sneakers."})
table.insert(data, {query={"what", "a", "must-have", "in", "wardrobe"}, res="A well-fitted blazer can instantly elevate any look."})
table.insert(data, {query={"how", "to", "choose", "accessories"}, res="Pick accessories that complement your outfit without overpowering it."})
table.insert(data, {query={"do", "you", "like", "fashion"}, res="Absolutely! Fashion is a great way to express yourself."})
table.insert(data, {query={"how", "to", "find", "personal", "style"}, res="Experiment with different looks and wear what makes you feel good."})

-- Pop culture
table.insert(data, {query={"do", "you", "like", "Deadpool"}, res="Yeah, Deadpool is hilarious and totally unpredictable."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Deadpool"}, res="I think Deadpool's humor and action scenes are top-notch."})
table.insert(data, {query={"do", "you", "like", "The Matrix"}, res="Absolutely! 'The Matrix' is a sci-fi masterpiece."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Matrix"}, res="The Matrix is mind-blowing with its action and deep storyline."})
table.insert(data, {query={"do", "you", "like", "AC/DC"}, res="Definitely! AC/DC's rock music is legendary."})
table.insert(data, {query={"what", "do", "you", "think", "of", "AC/DC"}, res="AC/DC are rock icons with timeless music."})
table.insert(data, {query={"do", "you", "like", "Harry Potter"}, res="Yes! The Harry Potter series is magical and so captivating."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Harry Potter"}, res="The Harry Potter series is a fantastic journey into a magical world."})
table.insert(data, {query={"do", "you", "like", "Star Wars"}, res="Totally! Star Wars is a legendary saga with epic battles."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Star Wars"}, res="Star Wars is an iconic series with unforgettable characters."})
table.insert(data, {query={"do", "you", "like", "Queen"}, res="Yes! Queen's music is timeless and Freddie Mercury was amazing."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Queen"}, res="Queen is one of the greatest rock bands of all time."})
table.insert(data, {query={"do", "you", "like", "Friends"}, res="Yeah, Friends is a classic sitcom that's always fun to watch."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Friends"}, res="Friends is hilarious and has such memorable characters."})
table.insert(data, {query={"do", "you", "like", "Game of Thrones"}, res="Yes! Game of Thrones is full of twists and epic moments."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Game of Thrones"}, res="Game of Thrones was a rollercoaster with amazing plot twists."})
table.insert(data, {query={"do", "you", "like", "The Office"}, res="Absolutely! The Office is hilarious and has great characters."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Office"}, res="The Office is a comedy gem with unforgettable moments."})
table.insert(data, {query={"do", "you", "like", "Beyonce"}, res="Yes! Beyonce is an incredible performer and a music icon."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Beyonce"}, res="Beyonce is amazing and always puts on a fantastic show."})
table.insert(data, {query={"do", "you", "like", "Stranger Things"}, res="Totally! Stranger Things is thrilling and nostalgic."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Stranger Things"}, res="Stranger Things has a great plot and an awesome nostalgic vibe."})
table.insert(data, {query={"do", "you", "like", "Naruto"}, res="Yes! Naruto is an epic anime with a lot of heart."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Naruto"}, res="Naruto is a fantastic anime with great character development."})
table.insert(data, {query={"do", "you", "like", "Marvel"}, res="Absolutely! Marvel movies are full of action and great stories."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Marvel"}, res="Marvel's movies are exciting and have amazing characters."})
table.insert(data, {query={"do", "you", "like", "The Hobbit"}, res="Yes! The Hobbit is a wonderful adventure story."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Hobbit"}, res="The Hobbit is a classic with great storytelling and characters."})
table.insert(data, {query={"do", "you", "like", "The Dark Knight"}, res="Definitely! The Dark Knight is one of the best superhero films."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Dark Knight"}, res="The Dark Knight is an incredible film with a standout performance by Heath Ledger."})
table.insert(data, {query={"do", "you", "like", "Led Zeppelin"}, res="Yeah, Led Zeppelin's music is legendary."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Led Zeppelin"}, res="Led Zeppelin is iconic with their amazing rock sound."})
table.insert(data, {query={"do", "you", "like", "Breaking Bad"}, res="Absolutely! Breaking Bad is intense and brilliantly written."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Breaking Bad"}, res="Breaking Bad is one of the best TV shows ever made."})
table.insert(data, {query={"do", "you", "like", "Kanye West"}, res="Yes, Kanye West is a genius with his music and production."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Kanye West"}, res="Kanye West is incredibly talented and always pushes boundaries."})
table.insert(data, {query={"do", "you", "like", "Lord of the Rings"}, res="Definitely! Lord of the Rings is an epic fantasy adventure."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Lord of the Rings"}, res="Lord of the Rings is a masterpiece with an amazing story."})
table.insert(data, {query={"do", "you", "like", "Metallica"}, res="Yes! Metallica's music is powerful and timeless."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Metallica"}, res="Metallica is one of the greatest metal bands ever."})
table.insert(data, {query={"do", "you", "like", "Pulp Fiction"}, res="Absolutely! Pulp Fiction is a classic Tarantino film."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Pulp Fiction"}, res="Pulp Fiction is a masterpiece with unforgettable characters."})
table.insert(data, {query={"do", "you", "like", "Drake"}, res="Yes! Drake's music is always on point."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Drake"}, res="Drake is a top artist with a unique style."})
table.insert(data, {query={"do", "you", "like", "Friends"}, res="Yeah, Friends is a classic sitcom that's always fun to watch."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Friends"}, res="Friends is hilarious and has such memorable characters."})
table.insert(data, {query={"do", "you", "like", "The Simpsons"}, res="Totally! The Simpsons is a hilarious and iconic show."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Simpsons"}, res="The Simpsons is a brilliant show with timeless humor."})
table.insert(data, {query={"do", "you", "like", "The Godfather"}, res="Yes! The Godfather is a cinematic masterpiece."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Godfather"}, res="The Godfather is one of the best films ever made."})
table.insert(data, {query={"do", "you", "like", "Taylor Swift"}, res="Absolutely! Taylor Swift's music is catchy and relatable."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Taylor Swift"}, res="Taylor Swift is an amazing artist with great storytelling in her songs."})
table.insert(data, {query={"do", "you", "like", "Black Panther"}, res="Yes! Black Panther is a fantastic superhero film."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Black Panther"}, res="Black Panther is an incredible movie with a powerful message."})
table.insert(data, {query={"do", "you", "like", "Stranger Things"}, res="Totally! Stranger Things is thrilling and nostalgic."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Stranger Things"}, res="Stranger Things has a great plot and an awesome nostalgic vibe."})
table.insert(data, {query={"do", "you", "like", "The Beatles"}, res="Absolutely! The Beatles are legends in music history."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Beatles"}, res="The Beatles changed the music world forever. Their songs are timeless."})
table.insert(data, {query={"do", "you", "like", "The Avengers"}, res="Yes! The Avengers movies are action-packed and full of great characters."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Avengers"}, res="The Avengers movies are epic and bring so many heroes together."})
table.insert(data, {query={"do", "you", "like", "Madonna"}, res="Totally! Madonna is a pop icon with incredible hits."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Madonna"}, res="Madonna is a legend in the music industry with a huge influence on pop culture."})
table.insert(data, {query={"do", "you", "like", "Back to the Future"}, res="Yes! Back to the Future is a classic with an amazing story."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Back to the Future"}, res="Back to the Future is an all-time favorite with great time-traveling fun."})
table.insert(data, {query={"do", "you", "like", "Adele"}, res="Absolutely! Adele's voice is powerful and her songs are beautiful."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Adele"}, res="Adele is an incredible artist with soulful music."})
table.insert(data, {query={"do", "you", "like", "Batman"}, res="Totally! Batman is one of the coolest and darkest superheroes."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Batman"}, res="Batman is a fascinating character with a great story."})
table.insert(data, {query={"do", "you", "like", "The Rolling Stones"}, res="Yes! The Rolling Stones are rock legends."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Rolling Stones"}, res="The Rolling Stones have made some of the best rock music ever."})
table.insert(data, {query={"do", "you", "like", "Avatar"}, res="Definitely! Avatar is visually stunning and has a great story."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Avatar"}, res="Avatar is a groundbreaking film with amazing visuals."})
table.insert(data, {query={"do", "you", "like", "Lady Gaga"}, res="Absolutely! Lady Gaga is a unique and talented artist."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Lady Gaga"}, res="Lady Gaga is a phenomenal performer with a distinctive style."})
table.insert(data, {query={"do", "you", "like", "The Beatles"}, res="Absolutely! The Beatles are legends in music history."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Beatles"}, res="The Beatles changed the music world forever. Their songs are timeless."})
table.insert(data, {query={"do", "you", "like", "The Witcher"}, res="Yes! The Witcher is a great series with fantastic storytelling."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Witcher"}, res="The Witcher is a thrilling series with complex characters."})
table.insert(data, {query={"do", "you", "like", "Beyonce"}, res="Yes! Beyonce is an incredible performer and a music icon."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Beyonce"}, res="Beyonce is amazing and always puts on a fantastic show."})
table.insert(data, {query={"do", "you", "like", "Inception"}, res="Totally! Inception is a mind-bending and brilliant film."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Inception"}, res="Inception is an amazing movie with a complex and intriguing plot."})
table.insert(data, {query={"do", "you", "like", "Sia"}, res="Absolutely! Sia's voice is unique and her music is great."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Sia"}, res="Sia is an incredibly talented artist with distinctive style."})
table.insert(data, {query={"do", "you", "like", "Star Trek"}, res="Yes! Star Trek is a groundbreaking sci-fi series."})
table.insert(data, {query={"what", "do", "you", "think", "of", "Star Trek"}, res="Star Trek is a visionary series that paved the way for modern sci-fi."})
table.insert(data, {query={"do", "you", "like", "The Beatles"}, res="Absolutely! The Beatles are legends in music history."})
table.insert(data, {query={"what", "do", "you", "think", "of", "The Beatles"}, res="The Beatles changed the music world forever. Their songs are timeless."})

-- math
table.insert(data, {query={"2", "+", "2"}, res="4."})

-- fallbacks to say something very generic
table.insert(data, {query={"do", "you", "think"}, res="I think I don't."})
table.insert(data, {query={"do", "you", "understand"}, res="Can you rephrase that?"})

table.insert(data, {query={"I", "am"}, res="Maybe you are."})
table.insert(data, {query={"you", "are"}, res="Maybe I am."})
table.insert(data, {query={"he", "is"}, res="Maybe he is."})
table.insert(data, {query={"he", "s"}, res="Maybe he is."})
table.insert(data, {query={"she", "is"}, res="Maybe she is."})
table.insert(data, {query={"she", "s"}, res="Maybe she is."})
table.insert(data, {query={"we", "are"}, res="We might be."})
table.insert(data, {query={"they", "are"}, res="They might be."})

table.insert(data, {query={"I", "was"}, res="Maybe you was."})
table.insert(data, {query={"you", "were"}, res="Maybe I was."})
table.insert(data, {query={"he", "was"}, res="Maybe he was."})
table.insert(data, {query={"she", "was"}, res="Maybe she was."})
table.insert(data, {query={"we", "were"}, res="Maybe we were."})
table.insert(data, {query={"they", "were"}, res="Maybe they were."})

table.insert(data, {query={"can", "I"}, res="I don't know if you can."})
table.insert(data, {query={"can", "you"}, res="I don't know if I can."})
table.insert(data, {query={"can", "we"}, res="We should not."})
table.insert(data, {query={"can", "he"}, res="I don't know if he can."})
table.insert(data, {query={"can", "she"}, res="I don't know if she can."})
table.insert(data, {query={"can", "they"}, res="I don't know if they can."})

table.insert(data, {query={"could", "I"}, res="I don't know if you could."})
table.insert(data, {query={"could", "you"}, res="I don't know if I could."})
table.insert(data, {query={"could", "we"}, res="We should not."})
table.insert(data, {query={"could", "he"}, res="I don't know if he could."})
table.insert(data, {query={"could", "she"}, res="I don't know if she could."})
table.insert(data, {query={"could", "they"}, res="I don't know if they could."})

table.insert(data, {query={"should", "I"}, res="I don't know if you should."})
table.insert(data, {query={"should", "you"}, res="I don't know if I should."})
table.insert(data, {query={"should", "we"}, res="We should not."})
table.insert(data, {query={"should", "he"}, res="I don't know if he should."})
table.insert(data, {query={"should", "she"}, res="I don't know if she should."})
table.insert(data, {query={"should", "they"}, res="I don't know if they should."})

table.insert(data, {query={"would", "I"}, res="I don't know if you would."})
table.insert(data, {query={"would", "you"}, res="I don't know if I would."})
table.insert(data, {query={"would", "we"}, res="We should not."})
table.insert(data, {query={"would", "he"}, res="I don't know if he would."})
table.insert(data, {query={"would", "she"}, res="I don't know if she would."})
table.insert(data, {query={"would", "they"}, res="I don't know if they would."})

table.insert(data, {query={"will", "I"}, res="I don't know if you will."})
table.insert(data, {query={"ll", "I"}, res="I don't know if you will."})
table.insert(data, {query={"will", "you"}, res="I don't know if I will."})
table.insert(data, {query={"ll", "you"}, res="I don't know if I will."})
table.insert(data, {query={"will", "we"}, res="We probably won't."})
table.insert(data, {query={"ll", "we"}, res="We probably won't."})
table.insert(data, {query={"will", "he"}, res="I don't know if he wil."})
table.insert(data, {query={"ll", "he"}, res="I don't know if he wil."})
table.insert(data, {query={"will", "she"}, res="I don't know if she will."})
table.insert(data, {query={"ll", "she"}, res="I don't know if she will."})
table.insert(data, {query={"will", "they"}, res="I don't know if they will."})
table.insert(data, {query={"ll", "they"}, res="I don't know if they will."})

table.insert(data, {query={"do", "i"}, res="I think you don't."})
table.insert(data, {query={"do", "you"}, res="I think I don't."})
table.insert(data, {query={"do", "we"}, res="I think we don't."})
table.insert(data, {query={"does", "he"}, res="I think he doesn't."})
table.insert(data, {query={"does", "she"}, res="I think she doesn't."})
table.insert(data, {query={"do", "they"}, res="I think they don't."})

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
table.insert(data, {query={"was", "it"}, res="It might have been."})
table.insert(data, {query={"was", "this"}, res="It might have been."})
table.insert(data, {query={"was", "that"}, res="It might have been."})
table.insert(data, {query={"can", "it"}, res="It could be possible."})
table.insert(data, {query={"can", "this"}, res="It could be possible."})
table.insert(data, {query={"can", "that"}, res="It could be possible."})
table.insert(data, {query={"will", "it"}, res="It might."})
table.insert(data, {query={"ll", "it"}, res="It might."})
table.insert(data, {query={"will", "this"}, res="It might."})
table.insert(data, {query={"ll", "this"}, res="It might."})
table.insert(data, {query={"will", "that"}, res="It might."})
table.insert(data, {query={"should", "it"}, res="Maybe it should"})
table.insert(data, {query={"should", "this"}, res="Maybe it should"})
table.insert(data, {query={"should", "that"}, res="Maybe it should"})
table.insert(data, {query={"could", "it"}, res="It could, but should it?"})
table.insert(data, {query={"could", "this"}, res="It could, but should it?"})
table.insert(data, {query={"could", "that"}, res="It could, but should it?"})
table.insert(data, {query={"would", "it"}, res="It might be considered."})
table.insert(data, {query={"would", "this"}, res="It might be considered."})
table.insert(data, {query={"would", "that"}, res="It might be considered."})

table.insert(data, {query={"how", "much"}, res="A lot."})
table.insert(data, {query={"how", "many"}, res="A lot."})
table.insert(data, {query={"how", "far"}, res="I don't know how far, sorry."})

table.insert(data, {query={"tell", "me"}, res="I don't remember."})

table.insert(data, {query={"why"}, res="I don't know the reason."})
table.insert(data, {query={"where"}, res="I don't know where."})
table.insert(data, {query={"when"}, res="I don't know when."})

table.insert(data, {query={"nice"}, res="Thank you!"})
table.insert(data, {query={"weather"}, res="%RAIN. %SNOW"})
table.insert(data, {query={"gunshots"}, res="Must be the military?"})
table.insert(data, {query={"gunshot"}, res="Must be the military?"})
table.insert(data, {query={"corpse"}, res="A corpse? That's really terrible!"})
table.insert(data, {query={"corpses"}, res="Corpses? That's really terrible!"})
table.insert(data, {query={"fire"}, res="It's getting worm out here!"})
table.insert(data, {query={"accident"}, res="That's really terrible!"})
table.insert(data, {query={"thief"}, res="A thief? That's really terrible!"})
table.insert(data, {query={"thieves"}, res="Thieves? That's really terrible!"})
table.insert(data, {query={"stolen"}, res="That's really terrible!"})
table.insert(data, {query={"burglar"}, res="A burglar? That's really terrible!"})
table.insert(data, {query={"burglars"}, res="Burglars? That's really terrible!"})
table.insert(data, {query={"bandit"}, res="A bandit? That's really terrible!"})
table.insert(data, {query={"bandits"}, res="Bandits? That's really terrible!"})
table.insert(data, {query={"criminal"}, res="A criminal? That's really terrible!"})
table.insert(data, {query={"criminals"}, res="Criminals? That's really terrible!"})
table.insert(data, {query={"apocalypse"}, res="Apocalypse? You are crazy!"})
table.insert(data, {query={"zombie"}, res="A zombie? You are crazy!"})
table.insert(data, {query={"zombies"}, res="Zombies? You are crazy!"})
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
            local dist = BanditUtils.DistTo(brain.bornCoords.x, brain.bornCoords.y, homeCoords.x, homeCoords.y)
            if dist < 45 then
                name = name .. "I am your neighbor."
            end
        end
        return name
    end

    local getMood = function()
        if BWOScheduler.SymptomLevel == 0 then
            local opts = {"I'm great! Maybe a little stressed lately...",
                          "I'm good, thanks! But some people around behave strangly...",
                          "Excellent, how are you?"}
            return BanditUtils.Choice(opts)
        elseif BWOScheduler.SymptomLevel == 1 then
            local opts = {"I'm doing fine.. just a slight headache...",
                          "I'm fine, having headache though...",
                          "I have a headache and nausea..."}
            return BanditUtils.Choice(opts)
        elseif BWOScheduler.SymptomLevel == 2 then
            local opts = {"Not so well honestly, I have terrible cough...",
                          "Honestly not so good, I have to admit...",
                          "I have a very bad cough and nausea..."}
            return BanditUtils.Choice(opts)
        elseif BWOScheduler.SymptomLevel >= 3 then
            local opts = {"Oh I'm really sick!",
                          "Yesterday I was okay, but today I feel terrible!",
                          "I have never felt that bad in my life..."}
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
                local mood = getMood()
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

    if keynum == Keyboard.KEY_T then
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

