package app.hypermedia.testing.dsl.ide.editor.contentassist

import org.eclipse.xtext.ide.editor.contentassist.IIdeContentProposalAcceptor
import org.eclipse.xtext.ide.editor.contentassist.ContentAssistContext
import org.eclipse.xtext.RuleCall

class HydraContentAssist extends CoreContentAssist {
    override dispatch void createProposals(RuleCall ruleCall, ContentAssistContext context, IIdeContentProposalAcceptor acceptor) {
        switch (ruleCall.rule.name) {
            case "RelaxedOperationBlock": {
                val entry = proposalCreator.createProposal('With Operation', context)
                acceptor.accept(entry, proposalPriorities.getDefaultPriority(entry))
            }
            case "OperationBlock": {
                var entry = proposalCreator.createProposal('With Operation', context)
                acceptor.accept(entry, proposalPriorities.getDefaultPriority(entry))
                entry = proposalCreator.createProposal('Expect Operation', context)
                acceptor.accept(entry, proposalPriorities.getDefaultPriority(entry))
            }
            default: {
                super._createProposals(ruleCall, context, acceptor)
            }
        }
    }
}