class BMRCalculator{
  int age;
  String gender;
  double height;
  double weight;

  BMRCalculator(this.age, this.gender,
  this.height, this.weight);

  int getBMR(){

    const double maleConst = 88.362; //Numerous constants are required for this calculation.
    const double maleWeightConst = 13.397;
    const double maleHeightConst = 4.799;
    const double maleAgeConst = 5.677;

    const double femaleConst = 447.593;
    const double femaleWeightConst = 9.247;
    const double femaleHeightConst = 3.098;
    const double femaleAgeConst = 4.330;

    gender = gender.toLowerCase();

    // ignore: non_constant_identifier_names
    double BMRcalc = 0;

    if(gender == "male"){
      BMRcalc = maleConst + (maleWeightConst * weight) +
      (maleHeightConst * height) - (maleAgeConst * age);
    }
    else if(gender == "female"){
      BMRcalc = femaleConst + (femaleWeightConst * weight) +
      (femaleHeightConst * height) - (femaleAgeConst * age);
    }
    else{
      BMRcalc = ((maleConst + (maleWeightConst * weight) +
      (maleHeightConst * height) - (maleAgeConst * age)) +
      (femaleConst + (femaleWeightConst * weight) +
      (femaleHeightConst * height) - (femaleAgeConst * age)))/2;
      }
    
    return (BMRcalc).round() + 300; //add 300 to finalise result (last part of formula)

  }

  
}