class Exercise{

  String name;
  double weight;
  int reps;
  int sets;
  List<int> repRange;

  Exercise(this.name, this.weight,
    this.reps, this.sets, this.repRange);

  incrementReps(){
    reps = reps + 1;
  }

  checkWeightIncrement(){
    if(reps >= repRange[1]){
      weight += 2.5;
      reps = repRange[0];
    }
    else if(reps <= repRange[0] - 1){
      weight -= 2.5;
      reps = repRange[1] - 1;
    }
  }

  String toParse() => "&$name/$weight/$reps/$sets/$repRange";
  
}