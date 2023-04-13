
class GameAppreview {
  final String steamid;
  final int votes_up;
  final int votes_funny;
  final String review;
  final double weighted_vote_score;

  GameAppreview({
    required this.steamid,
    required this.votes_up,
    required this.votes_funny,
    required this.review,
    required this.weighted_vote_score
  }

  );

  factory GameAppreview.fromJson(Map<String, dynamic> json) {
    return GameAppreview(
      steamid: json['author']['steamid'], // à vérifier
      votes_up: int.parse(json['votes_up']),
     votes_funny: int.parse(json['votes_funny']),
      weighted_vote_score: double.parse(json['weighted_vote_score']),
      review: json['review'],

    );
  }

}

