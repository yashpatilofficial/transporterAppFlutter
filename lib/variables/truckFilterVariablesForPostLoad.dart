class TruckFilterVariablesForPostLoad {
  List truckTypeTextList = [
    'Open Body',
    'Flatbed',
    'Trailer Dala Body',
    'Standard Container',
    'High Cube Container'
  ];

  List truckTypeValueList = [
    'OPEN_HALF_BODY',
    'FLATBED',
    'HALF_BODY_TRAILER',
    'STANDARD_CONTAINER',
    'HIGH_CUBE_CONTAINER'
  ];

  Map<String, List<int>> passingWeightList = {
    'OPEN_HALF_BODY': [7, 8, 9, 15, 16, 18, 19, 20, 21, 24, 25, 30, 0],
    'FLATBED': [16, 21, 24, 30, 32, 33, 34, 40, 0],
    'HALF_BODY_TRAILER': [
      27,
      28,
      29,
      30,
      31,
      32,
      33,
      34,
      35,
      36,
      37,
      38,
      39,
      40,
      41,
      42,
      0
    ],
    'STANDARD_CONTAINER': [6, 7, 9, 15, 18, 0],
    'HIGH_CUBE_CONTAINER': [6, 7, 9, 15, 18, 0],
  };

  Map<String, List<int>> totalTyresList = {
    'OPEN_HALF_BODY': [6, 8, 10, 12, 14, 16, 18, 20, 22, 0],
    'FLATBED': [6, 8, 10, 12, 14, 16, 18, 20, 22, 0],
    'HALF_BODY_TRAILER': [6, 8, 10, 12, 14, 16, 18, 20, 22, 0],
    'STANDARD_CONTAINER': [6, 8, 10, 12, 14, 16, 18, 20, 22, 0],
    'HIGH_CUBE_CONTAINER': [6, 8, 10, 12, 14, 16, 18, 20, 22, 0],
  };

  Map<String, List<int>> truckLengthList = {
    'OPEN_HALF_BODY': [40, 10, 0],
    'FLATBED': [10, 20, 50, 0],
    'HALF_BODY_TRAILER': [20, 40, 0],
    'STANDARD_CONTAINER': [10, 60, 0],
    'HIGH_CUBE_CONTAINER': [40, 50, 60, 0],
  };
}
