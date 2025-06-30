import 'dart:convert';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class AIBotService {
  static String get _apiKey => dotenv.env['OPENAI_API_KEY'] ?? '';
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';

  // Fallback answers
  static final Map<String, Map<String, List<String>>> _fallbackAnswers = {
    'Actor/Actress': {
      'A': [
        'Arnold Schwarzenegger',
        'Angelina Jolie',
        'Adam Sandler',
        'Anne Hathaway',
        'Al Pacino'
      ],
      'B': [
        'Brad Pitt',
        'Bruce Willis',
        'Ben Affleck',
        'Blake Lively',
        'Benedict Cumberbatch'
      ],
      'C': [
        'Chris Evans',
        'Cameron Diaz',
        'Christian Bale',
        'Charlize Theron',
        'Cate Blanchett'
      ],
      'D': [
        'Denzel Washington',
        'Drew Barrymore',
        'Daniel Craig',
        'Dwayne Johnson',
        'Dakota Johnson'
      ],
      'E': [
        'Emma Stone',
        'Eddie Murphy',
        'Emily Blunt',
        'Eva Mendes',
        'Ethan Hawke'
      ],
      'F': [
        'Frank Sinatra',
        'Frances McDormand',
        'Forest Whitaker',
        'Felicity Jones',
        'Finn Wolfhard'
      ],
      'G': [
        'George Clooney',
        'Gwyneth Paltrow',
        'Gary Oldman',
        'Gal Gadot',
        'Gerard Butler'
      ],
      'H': [
        'Hugh Jackman',
        'Halle Berry',
        'Harrison Ford',
        'Helen Mirren',
        'Henry Cavill'
      ],
      'I': [
        'Ian McKellen',
        'Idris Elba',
        'Isla Fisher',
        'Irina Shayk',
        'Isaac Oscar'
      ],
      'J': [
        'Johnny Depp',
        'Jennifer Lawrence',
        'Jake Gyllenhaal',
        'Julia Roberts',
        'James Franco'
      ],
      'K': [
        'Keanu Reeves',
        'Kate Winslet',
        'Kevin Hart',
        'Keira Knightley',
        'Kit Harington'
      ],
      'L': [
        'Leonardo DiCaprio',
        'Lucy Liu',
        'Liam Neeson',
        'Lady Gaga',
        'Luke Evans'
      ],
      'M': [
        'Morgan Freeman',
        'Meryl Streep',
        'Matt Damon',
        'Margot Robbie',
        'Michael Fassbender'
      ],
      'N': [
        'Nicolas Cage',
        'Natalie Portman',
        'Neil Patrick Harris',
        'Nicole Kidman',
        'Noah Centineo'
      ],
      'O': [
        'Orlando Bloom',
        'Octavia Spencer',
        'Owen Wilson',
        'Olivia Wilde',
        'Oscar Isaac'
      ],
      'P': [
        'Paul Rudd',
        'Penelope Cruz',
        'Patrick Stewart',
        'Priyanka Chopra',
        'Pedro Pascal'
      ],
      'Q': ['Queen Latifah', 'Quentin Tarantino', 'Quinta Brunson'],
      'R': [
        'Robert Downey Jr',
        'Reese Witherspoon',
        'Ryan Reynolds',
        'Rihanna',
        'Russell Crowe'
      ],
      'S': [
        'Samuel L Jackson',
        'Scarlett Johansson',
        'Steve Carell',
        'Sandra Bullock',
        'Sebastian Stan'
      ],
      'T': [
        'Tom Hanks',
        'Tina Fey',
        'Tom Cruise',
        'Taylor Swift',
        'Timothee Chalamet'
      ],
      'U': ['Uma Thurman', 'Usher', 'Uzo Aduba'],
      'V': [
        'Vin Diesel',
        'Viola Davis',
        'Vince Vaughn',
        'Vanessa Hudgens',
        'Victoria Justice'
      ],
      'W': [
        'Will Smith',
        'Winona Ryder',
        'Woody Harrelson',
        'Wonder Woman',
        'Willem Dafoe'
      ],
      'X': ['Xavier Dolan', 'Xander Berkeley'],
      'Y': ['Yara Shahidi', 'Yvonne Strahovski'],
      'Z': ['Zendaya', 'Zoe Saldana', 'Zac Efron'],
    },
    'City': {
      'A': ['Amsterdam', 'Atlanta', 'Austin', 'Ankara', 'Adelaide', 'Algiers'],
      'B': [
        'Boston',
        'Berlin',
        'Barcelona',
        'Bangkok',
        'Buenos Aires',
        'Brisbane'
      ],
      'C': [
        'Chicago',
        'Cairo',
        'Copenhagen',
        'Calgary',
        'Casablanca',
        'Chennai'
      ],
      'D': ['Denver', 'Dubai', 'Dublin', 'Delhi', 'Damascus', 'Doha'],
      'E': ['Edinburgh', 'El Paso', 'Edmonton', 'Essen', 'Eugene'],
      'F': ['Florence', 'Frankfurt', 'Fresno', 'Fort Worth', 'Fukuoka'],
      'G': ['Geneva', 'Glasgow', 'Guadalajara', 'Gold Coast', 'Gothenburg'],
      'H': ['Houston', 'Helsinki', 'Hamburg', 'Havana', 'Hanoi'],
      'I': ['Istanbul', 'Indianapolis', 'Islamabad', 'Innsbruck', 'Irvine'],
      'J': ['Jacksonville', 'Jerusalem', 'Jakarta', 'Johannesburg', 'Jeddah'],
      'K': ['Kansas City', 'Kiev', 'Kuala Lumpur', 'Karachi', 'Kingston'],
      'L': ['London', 'Los Angeles', 'Lisbon', 'Lima', 'Lagos', 'Lyon'],
      'M': ['Miami', 'Madrid', 'Montreal', 'Mumbai', 'Melbourne', 'Munich'],
      'N': ['New York', 'Naples', 'Nashville', 'Nairobi', 'Nice', 'Newcastle'],
      'O': ['Orlando', 'Oslo', 'Ottawa', 'Osaka', 'Oakland', 'Omaha'],
      'P': ['Paris', 'Philadelphia', 'Prague', 'Phoenix', 'Portland', 'Perth'],
      'Q': ['Quebec City', 'Quito', 'Queenstown'],
      'R': ['Rome', 'Rio de Janeiro', 'Riyadh', 'Rotterdam', 'Raleigh'],
      'S': ['Seattle', 'Sydney', 'Stockholm', 'Singapore', 'Seoul', 'Seville'],
      'T': ['Tokyo', 'Toronto', 'Tampa', 'Tehran', 'Toulouse', 'Tunis'],
      'U': ['Utrecht', 'Ulaanbaatar', 'Uppsala'],
      'V': ['Vancouver', 'Vienna', 'Venice', 'Valencia', 'Vilnius'],
      'W': ['Washington', 'Warsaw', 'Wellington', 'Wuhan', 'Winnipeg'],
      'X': ['Xian', 'Xiamen'],
      'Y': ['York', 'Yokohama', 'Yerevan'],
      'Z': ['Zurich', 'Zagreb', 'Zaragoza'],
    },
    'Animal': {
      'A': ['Ant', 'Alligator', 'Antelope', 'Armadillo', 'Alpaca', 'Aardvark'],
      'B': ['Bear', 'Bird', 'Butterfly', 'Bee', 'Bat', 'Buffalo'],
      'C': ['Cat', 'Cow', 'Chicken', 'Cheetah', 'Camel', 'Crab'],
      'D': ['Dog', 'Duck', 'Deer', 'Dolphin', 'Donkey', 'Dragonfly'],
      'E': ['Elephant', 'Eagle', 'Eel', 'Emu', 'Elk', 'Echidna'],
      'F': ['Fish', 'Fox', 'Frog', 'Flamingo', 'Falcon', 'Ferret'],
      'G': ['Giraffe', 'Goat', 'Gorilla', 'Goldfish', 'Gecko', 'Goose'],
      'H': ['Horse', 'Hippo', 'Hawk', 'Hamster', 'Hedgehog', 'Hummingbird'],
      'I': ['Iguana', 'Insect', 'Impala', 'Ibis'],
      'J': ['Jaguar', 'Jellyfish', 'Jackal', 'Jay', 'Jackrabbit'],
      'K': ['Kangaroo', 'Koala', 'Kiwi', 'Kingfisher', 'Koi'],
      'L': ['Lion', 'Lizard', 'Llama', 'Leopard', 'Lobster', 'Lemur'],
      'M': ['Monkey', 'Mouse', 'Moose', 'Mole', 'Mantis', 'Meerkat'],
      'N': ['Newt', 'Nightingale', 'Narwhal'],
      'O': ['Octopus', 'Owl', 'Otter', 'Ostrich', 'Orangutan', 'Ox'],
      'P': ['Pig', 'Penguin', 'Panda', 'Parrot', 'Peacock', 'Polar Bear'],
      'Q': ['Quail', 'Quokka'],
      'R': ['Rabbit', 'Rhino', 'Robin', 'Raccoon', 'Rat', 'Raven'],
      'S': ['Snake', 'Shark', 'Sheep', 'Squirrel', 'Swan', 'Seal'],
      'T': ['Tiger', 'Turtle', 'Turkey', 'Toucan', 'Tarantula', 'Tuna'],
      'U': ['Unicorn', 'Urchin', 'Uakari'],
      'V': ['Vulture', 'Viper', 'Vicuna'],
      'W': ['Wolf', 'Whale', 'Worm', 'Walrus', 'Woodpecker', 'Wombat'],
      'X': ['X-ray fish', 'Xerus'],
      'Y': ['Yak', 'Yellowfin Tuna'],
      'Z': ['Zebra', 'Zebu'],
    },
    'Food': {
      'A': ['Apple', 'Avocado', 'Artichoke', 'Asparagus', 'Apricot', 'Almond'],
      'B': ['Banana', 'Bread', 'Broccoli', 'Bacon', 'Beef', 'Blueberry'],
      'C': ['Carrot', 'Cheese', 'Chocolate', 'Chicken', 'Cherry', 'Cucumber'],
      'D': ['Donut', 'Duck', 'Dates', 'Dumplings', 'Dragonfruit'],
      'E': ['Egg', 'Eggplant', 'Enchilada', 'Edamame', 'Elderberry'],
      'F': ['Fish', 'Fries', 'Fruit', 'Fig', 'Falafel', 'Focaccia'],
      'G': ['Grapes', 'Garlic', 'Gum', 'Ginger', 'Guacamole', 'Grapefruit'],
      'H': ['Ham', 'Honey', 'Hot dog', 'Hummus', 'Hamburger', 'Halibut'],
      'I': ['Ice cream', 'Italian food', 'Icing'],
      'J': ['Jam', 'Juice', 'Jelly', 'Jalapeno', 'Jackfruit'],
      'K': ['Kiwi', 'Kale', 'Kimchi', 'Kebab'],
      'L': ['Lemon', 'Lettuce', 'Lobster', 'Lime', 'Lasagna', 'Lentils'],
      'M': ['Mango', 'Milk', 'Meat', 'Mushroom', 'Muffin', 'Melon'],
      'N': ['Nuts', 'Noodles', 'Nachos', 'Nutmeg'],
      'O': ['Orange', 'Onion', 'Oatmeal', 'Olive', 'Omelet', 'Oyster'],
      'P': ['Pizza', 'Pasta', 'Peach', 'Potato', 'Pineapple', 'Pork'],
      'Q': ['Quinoa', 'Quiche', 'Quesadilla'],
      'R': ['Rice', 'Radish', 'Raisins', 'Raspberry', 'Ramen', 'Ribs'],
      'S': ['Salad', 'Soup', 'Steak', 'Strawberry', 'Salmon', 'Spinach'],
      'T': ['Tomato', 'Turkey', 'Toast', 'Tuna', 'Tacos', 'Tea'],
      'U': ['Udon', 'Ugli fruit'],
      'V': ['Vegetables', 'Vanilla', 'Venison', 'Vinegar'],
      'W': ['Watermelon', 'Wine', 'Waffles', 'Walnut', 'Wheat', 'Wrap'],
      'X': ['Xigua', 'Ximenia'],
      'Y': ['Yogurt', 'Yam', 'Yeast'],
      'Z': ['Zucchini', 'Ziti'],
    },
    'Country': {
      'A': [
        'Australia',
        'Argentina',
        'Austria',
        'Algeria',
        'Angola',
        'Armenia'
      ],
      'B': [
        'Brazil',
        'Belgium',
        'Bangladesh',
        'Bulgaria',
        'Bolivia',
        'Botswana'
      ],
      'C': ['Canada', 'China', 'Chile', 'Colombia', 'Croatia', 'Cuba'],
      'D': ['Denmark', 'Dominican Republic', 'Djibouti'],
      'E': ['England', 'Egypt', 'Ethiopia', 'Ecuador', 'Estonia', 'Eritrea'],
      'F': ['France', 'Finland', 'Fiji', 'Faroe Islands'],
      'G': ['Germany', 'Greece', 'Ghana', 'Guatemala', 'Guinea', 'Georgia'],
      'H': ['Hungary', 'Haiti', 'Honduras', 'Hong Kong'],
      'I': ['Italy', 'India', 'Indonesia', 'Iran', 'Iraq', 'Ireland'],
      'J': ['Japan', 'Jordan', 'Jamaica', 'Jersey'],
      'K': ['Kenya', 'Kazakhstan', 'Kuwait', 'Kyrgyzstan'],
      'L': ['Libya', 'Lebanon', 'Laos', 'Latvia', 'Lithuania', 'Luxembourg'],
      'M': ['Mexico', 'Morocco', 'Malaysia', 'Mali', 'Malta', 'Mongolia'],
      'N': ['Norway', 'Netherlands', 'Nigeria', 'Nepal', 'Nicaragua', 'Niger'],
      'O': ['Oman', 'Oceania'],
      'P': ['Poland', 'Portugal', 'Peru', 'Philippines', 'Pakistan', 'Panama'],
      'Q': ['Qatar', 'Quebec'],
      'R': ['Russia', 'Romania', 'Rwanda', 'Republic of Congo'],
      'S': [
        'Spain',
        'Sweden',
        'Switzerland',
        'Singapore',
        'South Africa',
        'Syria'
      ],
      'T': ['Turkey', 'Thailand', 'Tunisia', 'Tanzania', 'Taiwan', 'Togo'],
      'U': ['United States', 'Ukraine', 'Uruguay', 'Uganda', 'Uzbekistan'],
      'V': ['Venezuela', 'Vietnam', 'Vatican City'],
      'W': ['Wales', 'Western Sahara'],
      'X': ['Xinjiang'],
      'Y': ['Yemen', 'Yugoslavia'],
      'Z': ['Zimbabwe', 'Zambia'],
    },
    'Movie': {
      'A': ['Avatar', 'Avengers', 'Alien', 'Aladdin', 'Amadeus', 'Anchorman'],
      'B': [
        'Batman',
        'Blade Runner',
        'Braveheart',
        'Bambi',
        'Borat',
        'Beetlejuice'
      ],
      'C': ['Casablanca', 'Citizen Kane', 'Cars', 'Coco', 'Casino', 'Chicago'],
      'D': ['Dune', 'Django', 'Dumbo', 'Deadpool', 'Die Hard', 'Dracula'],
      'E': ['E.T.', 'Elf', 'Encanto', 'Eternals', 'Exodus', 'Elysium'],
      'F': [
        'Frozen',
        'Forrest Gump',
        'Fight Club',
        'Finding Nemo',
        'Fast Five',
        'Fargo'
      ],
      'G': [
        'Gladiator',
        'Godfather',
        'Gravity',
        'Goodfellas',
        'Ghostbusters',
        'Godzilla'
      ],
      'H': ['Harry Potter', 'Home Alone', 'Hulk', 'Her', 'Heat', 'Halloween'],
      'I': [
        'Inception',
        'Iron Man',
        'Indiana Jones',
        'Inside Out',
        'Interstellar',
        'It'
      ],
      'J': [
        'Jaws',
        'Joker',
        'Jurassic Park',
        'John Wick',
        'James Bond',
        'Juno'
      ],
      'K': ['King Kong', 'Kill Bill', 'Knives Out', 'Kung Fu Panda'],
      'L': [
        'Lion King',
        'Lord of the Rings',
        'La La Land',
        'Logan',
        'Luca',
        'Loki'
      ],
      'M': [
        'Matrix',
        'Marvel',
        'Moana',
        'Mulan',
        'Mad Max',
        'Mission Impossible'
      ],
      'N': ['Nemo', 'No Time to Die', 'Nightmare', 'Napoleon', 'Nebraska'],
      'O': ['Oppenheimer', 'Ocean\'s Eleven', 'Onward', 'Oz', 'Oldboy'],
      'P': [
        'Pulp Fiction',
        'Pirates',
        'Pixar',
        'Psycho',
        'Parasite',
        'Predator'
      ],
      'Q': ['Queen', 'Quantum', 'Quiz Show'],
      'R': ['Rocky', 'Ratatouille', 'Rush', 'Roma', 'Rambo', 'Robin Hood'],
      'S': [
        'Star Wars',
        'Shrek',
        'Spider-Man',
        'Scarface',
        'Shining',
        'Superman'
      ],
      'T': [
        'Titanic',
        'Toy Story',
        'Thor',
        'Terminator',
        'Top Gun',
        'Transformers'
      ],
      'U': ['Up', 'Uncharted', 'Underworld', 'Us'],
      'V': ['Venom', 'Vertigo', 'V for Vendetta', 'Valkyrie'],
      'W': ['Wonder Woman', 'Wall-E', 'Wolverine', 'Watchmen', 'Willy Wonka'],
      'X': ['X-Men', 'XXX'],
      'Y': ['Yesterday', 'Youth'],
      'Z': ['Zootopia', 'Zodiac', 'Zombieland'],
    },
    'Brand': {
      'A': ['Apple', 'Amazon', 'Adidas', 'Audi', 'Adobe', 'American Express'],
      'B': ['BMW', 'Burger King', 'Boeing', 'Bose', 'Bentley', 'Budweiser'],
      'C': ['Coca-Cola', 'Canon', 'Chanel', 'Chevrolet', 'Cisco', 'Cartier'],
      'D': ['Disney', 'Dell', 'Dior', 'Dominos', 'Dunkin', 'Dyson'],
      'E': ['eBay', 'ESPN', 'Exxon', 'Etsy', 'Emirates'],
      'F': ['Facebook', 'Ferrari', 'Ford', 'FedEx', 'Fendi', 'Fiat'],
      'G': [
        'Google',
        'Gucci',
        'General Motors',
        'Gap',
        'Gillette',
        'Goldman Sachs'
      ],
      'H': ['Honda', 'HP', 'Hermes', 'Hilton', 'Harley Davidson', 'H&M'],
      'I': ['IBM', 'Intel', 'IKEA', 'Instagram', 'Infiniti'],
      'J': ['Johnson & Johnson', 'JPMorgan', 'Jaguar', 'JetBlue'],
      'K': ['KFC', 'Kellogg\'s', 'Kraft', 'Kia'],
      'L': [
        'Louis Vuitton',
        'Lexus',
        'L\'Oreal',
        'LinkedIn',
        'Lego',
        'Lamborghini'
      ],
      'M': [
        'McDonald\'s',
        'Microsoft',
        'Mercedes',
        'Mastercard',
        'Marlboro',
        'MTV'
      ],
      'N': ['Nike', 'Netflix', 'Nestle', 'Nintendo', 'Nikon', 'Nokia'],
      'O': ['Oracle', 'Omega', 'Old Spice'],
      'P': ['Pepsi', 'Porsche', 'Prada', 'PayPal', 'Puma', 'Panasonic'],
      'Q': ['Qualcomm', 'Qatar Airways'],
      'R': ['Rolex', 'Red Bull', 'Ralph Lauren', 'Reuters', 'Reebok'],
      'S': ['Samsung', 'Starbucks', 'Sony', 'Shell', 'Spotify', 'Subway'],
      'T': ['Toyota', 'Tesla', 'Tiffany', 'Twitter', 'Target', 'TikTok'],
      'U': ['Uber', 'Under Armour', 'UPS', 'Unilever'],
      'V': ['Visa', 'Volkswagen', 'Versace', 'Verizon', 'Volvo'],
      'W': ['Walmart', 'WhatsApp', 'Wells Fargo', 'Warner Bros'],
      'X': ['Xbox', 'Xerox'],
      'Y': ['YouTube', 'Yahoo', 'Yamaha'],
      'Z': ['Zara', 'Zoom', 'Zeppelin'],
    },
    'Sport': {
      'A': ['Archery', 'Athletics', 'American Football', 'Alpine Skiing'],
      'B': [
        'Basketball',
        'Baseball',
        'Boxing',
        'Badminton',
        'Bowling',
        'Biathlon'
      ],
      'C': ['Cricket', 'Cycling', 'Chess', 'Climbing', 'Canoeing', 'Curling'],
      'D': ['Diving', 'Darts', 'Decathlon', 'Dodgeball'],
      'E': ['Equestrian', 'Esports'],
      'F': ['Football', 'Fencing', 'Figure Skating', 'Field Hockey', 'Fishing'],
      'G': ['Golf', 'Gymnastics', 'Gliding'],
      'H': ['Hockey', 'Handball', 'Hurdles', 'Hang Gliding'],
      'I': ['Ice Hockey', 'Ice Skating'],
      'J': ['Judo', 'Javelin', 'Jet Skiing'],
      'K': ['Karate', 'Kayaking', 'Kendo'],
      'L': ['Lacrosse', 'Long Jump'],
      'M': ['Marathon', 'Mixed Martial Arts', 'Motocross', 'Mountain Biking'],
      'N': ['Netball', 'Nordic Skiing'],
      'O': ['Olympics', 'Orienteering'],
      'P': ['Polo', 'Ping Pong', 'Parkour', 'Powerlifting', 'Parachuting'],
      'Q': ['Quidditch'],
      'R': ['Rugby', 'Running', 'Rowing', 'Rock Climbing', 'Racing'],
      'S': [
        'Soccer',
        'Swimming',
        'Skiing',
        'Surfing',
        'Skateboarding',
        'Squash'
      ],
      'T': [
        'Tennis',
        'Track and Field',
        'Triathlon',
        'Table Tennis',
        'Taekwondo'
      ],
      'U': ['Ultimate Frisbee', 'Underwater Hockey'],
      'V': ['Volleyball', 'Vaulting'],
      'W': ['Wrestling', 'Water Polo', 'Weightlifting', 'Windsurfing'],
      'X': ['X-Games'],
      'Y': ['Yachting', 'Yoga'],
      'Z': ['Zumba'],
    },
  };

  Future<String?> generateBotAnswer(
      String category, String letter, String botName) async {
    // If no API key, use fallback immediately
    if (_apiKey.isEmpty) {
      return _getFallbackAnswer(category, letter);
    }

    try {
      final prompt = '''
You are playing a word game as a bot named "$botName". 
Generate ONE answer for the category "$category" that starts with the letter "$letter".

Rules:
- Must start with "$letter" (case insensitive)
- Must be a valid example of "$category"
- Give a realistic answer that a human player might give
- Sometimes give popular answers, sometimes more creative ones
- Keep it simple and clear
- Respond with ONLY the answer, no explanation

Category: $category
Letter: $letter

Answer:''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
          'max_tokens': 20,
          'temperature': 0.8, // Higher temperature for more variety
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final answer =
            data['choices'][0]['message']['content'].toString().trim();

        // Validate the AI answer starts with correct letter
        if (answer.toLowerCase().startsWith(letter.toLowerCase())) {
          return answer;
        } else {
          print(
              'AI answer "$answer" doesn\'t start with "$letter", using fallback');
          return _getFallbackAnswer(category, letter);
        }
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return _getFallbackAnswer(category, letter);
      }
    } catch (e) {
      print('Bot answer generation error: $e');
      return _getFallbackAnswer(category, letter);
    }
  }

  String? _getFallbackAnswer(String category, String letter) {
    final categoryAnswers = _fallbackAnswers[category];
    if (categoryAnswers == null) return null;

    final letterAnswers = categoryAnswers[letter.toUpperCase()];
    if (letterAnswers == null || letterAnswers.isEmpty) return null;

    // Sometimes don't answer (to simulate human behavior)
    if (Random().nextDouble() < 0.15) {
      // 15% chance to not answer
      return null;
    }

    return letterAnswers[Random().nextInt(letterAnswers.length)];
  }

  // Generate multiple answers for a bot (for all categories)
  Future<Map<String, String>> generateBotAnswers(
      List<String> categories, String letter, String botName) async {
    Map<String, String> answers = {};

    // Add some realistic delay
    await Future.delayed(Duration(milliseconds: Random().nextInt(2000) + 1000));

    for (String category in categories) {
      final answer = await generateBotAnswer(category, letter, botName);
      if (answer != null) {
        answers[category] = answer;
      }

      // Small delay between categories to seem more human
      await Future.delayed(Duration(milliseconds: Random().nextInt(500) + 200));
    }

    return answers;
  }
}
