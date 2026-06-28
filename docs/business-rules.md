# Business Rules (Revised)

These business rules describe the relationships in the Soccer Competition Database. This is a **revised version** that incorporates marker feedback: business rules 7, 17 have corrected descriptors, and the Substitution relationship (old rule 19) has been removed because substitutions are captured within `GamePlayer` (via `gameMinute` and the "Substitute" start position) rather than in a separate table.

1. **CompetitionWeek and Game**
   - 1a. A CompetitionWeek includes one or more than one Game.
   - 1b. A Game is played in one and only one CompetitionWeek.

2. **Game and GameReferee**
   - 2a. A Game appears in one or more than one GameReferee.
   - 2b. A GameReferee supervises one and only one Game.

3. **Referee and GameReferee**
   - 3a. A Referee appears in one or more than one GameReferee.
   - 3b. A GameReferee records one and only one Referee.

4. **Ground and Game**
   - 4a. A Ground hosts one or more than one Game.
   - 4b. A Game takes place at one and only one Ground.

5. **Game and ClubGame**
   - 5a. A Game is recorded in one or more than one ClubGame.
   - 5b. A ClubGame records one and only one Game.

6. **Club and ClubGame**
   - 6a. A ClubGame records one and only one Club.
   - 6b. A Club plays in one or more than one ClubGame.

7. **Club and Ground** *(corrected: this relationship is about training/ownership, not where games are played)*
   - 7a. A Club trains at one and only one Ground.
   - 7b. A Ground is managed by one and only one Club.

8. **Game and GamePlayer**
   - 8a. A GamePlayer records one and only one Game.
   - 8b. A Game is recorded in one or more than one GamePlayer.

9. **GamePlayer and AwardedCard**
   - 9a. A GamePlayer gets one or more than one AwardedCard.
   - 9b. An AwardedCard records one and only one GamePlayer.

10. **GameReferee and AwardedCard**
    - 10a. A GameReferee appears in one or more than one AwardedCard.
    - 10b. An AwardedCard is issued by one and only one GameReferee.

11. **BestOnGround and BOGPlayer**
    - 11a. A BestOnGround appears in one or more than one BOGPlayer.
    - 11b. A BOGPlayer records one and only one BestOnGround.

12. **GamePlayer and BOGPlayer**
    - 12a. A GamePlayer appears in one or more than one BOGPlayer.
    - 12b. A BOGPlayer records one and only one GamePlayer.

13. **Result and ClubGame**
    - 13a. A Result records one or more than one ClubGame.
    - 13b. A ClubGame has one and only one Result.

14. **Club and Player**
    - 14a. A Club has one or more than one Player.
    - 14b. A Player participates in one and only one Club.

15. **Club and Coach**
    - 15a. A Club has one and only one Coach.
    - 15b. A Coach works for one and only one Club.

16. **Player and GamePlayer**
    - 16a. A Player participates in one or more than one GamePlayer.
    - 16b. A GamePlayer records one and only one Player.

17. **GamePlayer and ScoredGoal** *(corrected descriptor)*
    - 17a. A GamePlayer scores one or more than one ScoredGoal.
    - 17b. A ScoredGoal records one and only one GamePlayer.

18. **StartPosition and GamePlayer**
    - 18a. A StartPosition is assigned to one or more than one GamePlayer.
    - 18b. A GamePlayer has one and only one StartPosition.
