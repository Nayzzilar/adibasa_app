import 'package:adibasa_app/models/level.dart';

List<Level> getLevels() {
    List<Level> levels = [];

    levels.add(
      Level(
        level: 1,
        name: 'Level 1',
        description: 'Introduction to Adibasa',
        stars: 0,
        isLocked: false,
      ),
    );
    levels.add(
      Level(
        level: 2,
        name: 'Level 2',
        description: 'Basic Vocabulary',
        stars: 1,
        isLocked: false,
      ),
    );
    levels.add(
      Level(
        level: 3,
        name: 'Level 3',
        description: 'Simple Sentences',
        stars: 2,
        isLocked: false,
      ),
    );
    levels.add(
      Level(
        level: 4,
        name: 'Level 4',
        description: 'Intermediate Vocabulary',
        stars: 0,
        isLocked: false,
      ),
    );
    levels.add(
      Level(
        level: 5,
        name: 'Level 5',
        description: 'Complex Sentences',
        stars: 3,
        isLocked: true,
      ),
    );
    levels.add(
      Level(
        level: 6,
        name: 'Level 6',
        description: 'Advanced Vocabulary',
        stars: 3,
        isLocked: true,
      ),
    );
    levels.add(
      Level(
        level: 7,
        name: 'Level 7',
        description: 'Conversational Skills',
        stars: 3,
        isLocked: true,
      ),
    );
    levels.add(
      Level(
        level: 8,
        name: 'Level 8',
        description: 'Fluency Practice',
        stars: 3,
        isLocked: true,
      ),
    );
    levels.add(
      Level(
        level: 9,
        name: 'Level 9',
        description: 'Cultural Contexts',
        stars: 3,
        isLocked: true,
      ),
    );
    levels.add(
      Level(
        level: 10,
        name: 'Level 10',
        description: 'Mastery of Adibasa',
        stars: 3,
        isLocked: true,
      ),
    );

    return levels;
  }

  //   @override
  //   String toString() {
  //     levelSelection.add(
  //       Level(level: 1, name: 'Level 1', description: 'Introduction to Adibasa'),
  //       Level(level: 2, name: 'Level 2', description: 'Basic Vocabulary'),
  //       Level(level: 3, name: 'Level 3', description: 'Simple Sentences'),
  //       Level(level: 4, name: 'Level 4', description: 'Intermediate Vocabulary'),
  //       Level(level: 5, name: 'Level 5', description: 'Complex Sentences'),
  //       Level(level: 6, name: 'Level 6', description: 'Advanced Vocabulary'),
  //       Level(level: 7, name: 'Level 7', description: 'Conversational Skills'),
  //       Level(level: 8, name: 'Level 8', description: 'Fluency Practice'),
  //       Level(level: 9, name: 'Level 9', description: 'Cultural Contexts'),
  //       Level(level: 10, name: 'Level 10', description: 'Mastery of Adibasa'),
  //     );
  //     return 'Level $level: $name - $description';
  //     return levelSelection;
  //   }

