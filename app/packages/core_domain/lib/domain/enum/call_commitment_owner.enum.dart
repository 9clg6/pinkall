/// Participant responsible for an explicit post-call commitment.
enum CallCommitmentOwner {
  /// The Pinkall user owns the commitment.
  seller,

  /// The called prospect owns the commitment.
  prospect,

  /// Both participants share the commitment.
  mutual,
}
