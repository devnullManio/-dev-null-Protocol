// contracts/self_destruct_nft/src/lib.rs
use solana_program::{
    account_info::{AccountInfo, next_account_info},
    entrypoint::ProgramResult,
    program::invoke_signed,
    system_instruction,
};

pub fn process_destruction(
    accounts: &[AccountInfo],
    entropy: [u8; 32],
) -> ProgramResult {
    let account_info_iter = &mut accounts.iter();
    let nft_account = next_account_info(account_info_iter)?;
    let owner_account = next_account_info(account_info_iter)?;
    
    let mut rng = ChaChaRng::from_seed(entropy);
    let destruction_threshold = rng.gen_range(0..=100);
    
    if destruction_threshold > 66 {
        let close_ix = system_instruction::transfer(
            nft_account.key,
            owner_account.key,
            nft_account.lamports(),
        );
        
        invoke_signed(
            &close_ix,
            &[nft_account.clone(), owner_account.clone()],
            &[],
        )?;
    }
    
    Ok(())
}
