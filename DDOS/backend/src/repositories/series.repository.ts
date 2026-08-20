export class SeriesRepository {
  async findAll() {
    return [
      {
        id: 1,
        title: "JavaScript Basics",
        description: "Learn JavaScript from basics",
      },
      {
        id: 2,
        title: "React Basics",
        description: "Learn React from basics",
      },
      {
        id: 3,
        title: "Node.js Basics",
        description: "Learn Node.js and Express",
      },
    ];
  }
}