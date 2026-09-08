use codex_tools::FreeformTool;
use codex_tools::ToolSpec;

const APPLY_PATCH_LARK_GRAMMAR: &str = include_str!("../../../assets/tools/apply_patch.lark");

/// Returns a custom tool that can be used to edit files.
pub fn create_apply_patch_freeform_tool(include_environment_id: bool) -> ToolSpec {
    let definition = if include_environment_id {
        APPLY_PATCH_LARK_GRAMMAR.replace(
            "start: begin_patch hunk+ end_patch",
            "start: begin_patch environment_id? hunk+ end_patch\nenvironment_id: \"*** Environment ID: \" filename LF",
        )
    } else {
        APPLY_PATCH_LARK_GRAMMAR.to_string()
    };
    ToolSpec::Freeform(FreeformTool {
        name: "apply_patch".to_string(),
        description: format!(
            "The `apply_patch` tool can be used to edit files. This is a FREEFORM tool, so do not wrap the patch in JSON.\n\nInput must follow this Lark grammar:\n```lark\n{definition}\n```"
        ),
        defer_loading: None,
    })
}

#[cfg(test)]
#[path = "apply_patch_spec_tests.rs"]
mod tests;
