use super::*;
use pretty_assertions::assert_eq;

#[test]
fn create_apply_patch_freeform_tool_matches_expected_spec() {
    assert_eq!(
        create_apply_patch_freeform_tool(/*include_environment_id*/ false),
        ToolSpec::Freeform(FreeformTool {
            name: "apply_patch".to_string(),
            description: format!(
                "The `apply_patch` tool can be used to edit files. This is a FREEFORM tool, so do not wrap the patch in JSON.\n\nInput must follow this Lark grammar:\n```lark\n{APPLY_PATCH_LARK_GRAMMAR}\n```"
            ),
            defer_loading: None,
        })
    );
}

#[test]
fn create_apply_patch_freeform_tool_includes_environment_id_when_requested() {
    let ToolSpec::Freeform(tool) =
        create_apply_patch_freeform_tool(/*include_environment_id*/ true)
    else {
        panic!("expected freeform tool");
    };

    assert!(tool.description.contains("environment_id?"));
    assert!(
        tool.description
            .contains("\"*** Environment ID: \" filename LF")
    );
}
