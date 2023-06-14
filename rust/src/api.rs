use iota_client::{block::BlockId, Client};
use tokio::runtime::Runtime;
use anyhow::Result;

pub fn publish_tagged_data_block(tag: String, message: String) -> Result<String> {
    let node_url: String = String::from("https://api.shimmer.network");

    let rt = Runtime::new().unwrap();
    rt.block_on(async {
        // Create a client with that node.
        let client = Client::builder().with_node(&node_url)?.finish()?;

        // Create and send the block with tag and data.
        let block = client
            .block()
            .with_tag(tag.into_bytes())
            .with_data(message.into_bytes())
            .finish()
            .await?;

        let block_id:BlockId = block.id();

        Ok(block_id.to_string())
    })
}