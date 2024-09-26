package app.hypermedia.testing.dsl.ide.editor.contentassist

import org.eclipse.xtext.ide.editor.contentassist.IdeContentProposalProvider
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.ide.editor.contentassist.IIdeContentProposalAcceptor
import org.eclipse.xtext.RuleCall
import org.eclipse.xtext.Keyword

class CoreContentAssist extends IdeContentProposalProvider {
    override dispatch void createProposals(RuleCall ruleCall, ContentAssistContext context, IIdeContentProposalAcceptor acceptor) {
        switch (ruleCall.rule.name) {
            case "ClassBlock": {
                val entry = proposalCreator.createProposal('With Class', context)
                acceptor.accept(entry, proposalPriorities.getDefaultPriority(entry))
            }
            case "FollowStatement": {
                val entry = proposalCreator.createProposal('Follow [uri]', context)
                acceptor.accept(entry, proposalPriorities.getDefaultPriority(entry))
            }
        }
    }
    
    override protected filterKeyword(Keyword keyword, ContentAssistContext context) {
        if (keyword.value == "Follow") {
            return false
        }
        
        super.filterKeyword(keyword, context)
    }
    
}