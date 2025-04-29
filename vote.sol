// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

/// @title Vote avec delegation
contract Ballot {
    // Declaration d'un nouveau contrat
    // qui peut etre utilise par des variables plus tard
    // Il representera un seul electeur

    struct Voter    {
        uint weight; // poids cumule par delegation
        bool voted;
        address delegate;
        uint vote;  // index de la proposition votee
    }

    // Un type par proposition votee
    struct Proposal {
        bytes32 name;
        uint voteCount;
    }

    address public president;

    // Variable d'etat qui stocke une structure 'Voter' pour chaque adresse possible
    mapping(address => Voter) public voters;

    // Tableau de taille dynamique de structures Proposal
    Proposal[] public proposals;

    // Creation d'un nouveau bulletin de vote pour choisir l'un des proposalNames

    constructor(bytes32[] memory proposalNames) {
        president = msg.sender;
        voters[president].weight = 1;
    

        // Pour chacun des noms de proposition fournis, creer un nouvel objet
        // de proposition et l'ajouter a la fin du tableau

        for (uint i = 0; i < proposalNames.length; i++ )   {
            // 'Proposal({...}) cree un objet temporaire de proposition et 'proposal.push()'
            // l'ajoute a la fin des proposals.
            proposals.push(Proposal({
                name: proposalNames[i],
                voteCount: 0
            }));
        }
    }
    
    // Donne a 'voter' le droit de voter sur ce bulletin de vote.
    // Ne peut etre appele president

    function giveRightToVote(address voter) external {

        // Si le premier argument de 'require' est false, l'execution de termine et toutes les
        // modifications de l'etat et des soldes Ether sont annulees. 
        require(
            msg.sender == president,
            "Seul le president peut donner le droit de vote"
        );
        require(
            !voters[voter].voted,
            "L'electeur a deja vote"
        );

        require(voters[voter].weight == 0);

        voters[voter].weight = 1;
    }

    // function giveRightToAllVoter(address voter) external {

    //     // Si le premier argument de 'require' est false, l'execution de termine et toutes les
    //     // modifications de l'etat et des soldes Ether sont annulees. 
    //     require(
    //         msg.sender == president,
    //         "Seul le president peut donner le droit de vote"
    //     );

    //     // Boucle qui parcours l'array 'voters' et leur assigne un droit de vote
    //     // a la condition qu'ils n'aient pas deja vote
    //     for (uint v = 0; v < voters.length; v++)
    //     require(voters[voter].weight == 0);

    //     voters[voter].weight = 1;
    // }


    // Delegation du vote au votant 'to'
    function delegate (address to) external {
        // attribue une reference

        Voter storage sender = voters[msg.sender];

        require(!sender.voted, "Vous avez deja vote");
        require(to != msg.sender, "Autodelegation interdite, coquin!");

        while (voters[to].delegate != address(0))   {
            to = voters[to].delegate;

            require(to != msg.sender, "Found Loop in delegation");

        // Puisque sender est une reference, cela modifie 'voters[msg.sender].voted'
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate_ = voters[to];
        if (delegate_.voted)    {
            // Si le delegue a deja vote
            // ajouter directement au nb de votes
            proposals[delegate_.vote].voteCount += sender.weight;
        }
        else    {
            // Si le delegue n'a pas vote, ajouter a son poids
            delegate_.weight += sender.weight;
            }
        }
    }

    // Donner votre vote a la proposition 'propositions[proposition].nom'

    function vote(uint proposal) external {
        Voter storage sender = voters[msg.sender];

        require(sender.weight != 0, "n'a pas le droit de voter");
        require(!sender.voted, 'Deja vote');

        sender.voted = true;
        sender.vote = proposal;

        proposals[proposal].voteCount += sender.weight;
    }

    // @dev Calcule la proposition gagnante en prenant tous les votes precedents en compte
    function winningProposal() public view 
        returns (uint winninProposal_)
    {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount)  {
                winningVoteCount = proposals[p].voteCount;
                winninProposal_ = p;
            }
        }
    }

    // Appelle la fonction winProposal() pour obtenir l'index du gagnant contenu dans le tableau
    // des propositions. 
    function winnerName() external view
        returns (bytes32 winnerName_)
    {
        winnerName_ = proposals[winningProposal()].name;
    }
}