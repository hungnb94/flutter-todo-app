import 'dart:collection';

class TwoSum {
  List<int> twoSum(List<int> nums, int target) {
    var seen = HashMap<int, int>();
    for (int i = 0; i < nums.length; i++) {
      var nb = nums[i];
      var complement = target - nb;
      if (seen.containsKey(complement)) {
        return [seen[complement]!, i].toList();
      }
      seen[nb] = i;
    }
    return [];
  }
}

void main() {
  var solution = TwoSum();
  assert(solution.twoSum([2, 7, 11, 15], 9).toString() == [0, 1].toString());
  assert(solution.twoSum([3, 2, 4], 6).toString() == [1, 2].toString());
  assert(solution.twoSum([3, 3], 6).toString() == [0, 1].toString());
}